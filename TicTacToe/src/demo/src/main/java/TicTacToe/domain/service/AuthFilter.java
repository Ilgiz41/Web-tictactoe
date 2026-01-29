package TicTacToe.domain.service;

import TicTacToe.domain.model.User;
import TicTacToe.security.model.JwtAuthentication;
import TicTacToe.security.model.JwtResponse;
import TicTacToe.security.service.JwtProvider;
import TicTacToe.security.service.WebUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.GenericFilterBean;

import java.io.IOException;

@Component
@AllArgsConstructor
public class AuthFilter extends GenericFilterBean {

    private final JwtProvider jwtProvider;
    private final AuthenticationService authenticationService;
    private final WebUtil webUtil;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String token = webUtil.getCookieValue(httpRequest, "JWTAccessToken");
        String refreshToken = webUtil.getCookieValue(httpRequest, "JWTRefreshToken");
        JwtResponse jwtResponse = new JwtResponse(token, refreshToken);

        if (token == null || refreshToken == null) {
            chain.doFilter(request, response);
            return;
        }

        if (!jwtProvider.validateToken(token)) {
            JwtResponse newJwtResponse = authenticationService.refreshAccessToken(refreshToken);
            if (newJwtResponse == null) {
                chain.doFilter(request, response);
                return;
            }
            jwtResponse = newJwtResponse;
            webUtil.addCookie(httpResponse, "JWTAccessToken", jwtResponse.getAccessToken(), false);
        }

        try {
            User user = authenticationService.authenticate(jwtResponse.getAccessToken());
            SecurityContextHolder.getContext().setAuthentication(new JwtAuthentication(true, user.getId(), user.getRoles()));
        } catch (AuthenticationException e) {
            SecurityContextHolder.clearContext();
        }

        chain.doFilter(request, response);
    }
}