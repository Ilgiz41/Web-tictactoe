package TicTacToe.datasource.model;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;

@Entity
@Table(name = "roles")
@Data
public class EntityRole implements GrantedAuthority {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private int id;
    @Column
    private String name;

    @Override
    public String getAuthority() {
        return name;
    }

    public EntityRole(String role) {
        this.name = role;
    }

    public EntityRole() {

    }
}
