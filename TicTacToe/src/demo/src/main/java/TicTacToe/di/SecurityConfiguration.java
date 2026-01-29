package TicTacToe.di;

import TicTacToe.domain.service.AuthFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, AuthFilter authFilter) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(authorizeRequests -> authorizeRequests
                        .requestMatchers("/static/images/**").permitAll()
                        .requestMatchers("/static/css/**").permitAll()
                        .requestMatchers("/webjars/**").permitAll()
                        .requestMatchers("/signUp", "/signIn", "/static/images/favicon.ico").permitAll()
                        .requestMatchers(HttpMethod.POST, "/signUp").permitAll()
                        .requestMatchers(HttpMethod.POST, "/signIn").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(authFilter, UsernamePasswordAuthenticationFilter.class)
                .formLogin(form -> form
                        .loginPage("/signIn")
                        .loginProcessingUrl("/perform_login")
                        .defaultSuccessUrl("/", true)
                        .failureUrl("/signIn?error=true")
                        .permitAll()
                )
                .httpBasic(AbstractHttpConfigurer::disable);
        return http.build();
    }
}
