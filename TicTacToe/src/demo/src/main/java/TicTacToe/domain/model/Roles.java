package TicTacToe.domain.model;

import org.springframework.security.core.GrantedAuthority;

public enum Roles implements GrantedAuthority {
    USER("USER"),
    ;

    private final String authority;

    Roles(String authority) {
        this.authority = authority;
    }

    @Override
    public String getAuthority() {
        return authority;
    }
}
