package TicTacToe.domain.model;

import TicTacToe.datasource.model.EntityRole;
import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Data
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(updatable = false, nullable = false)
    private UUID id;
    @Column(name = "username", unique = true, nullable = false)
    private String login;
    @Column(name = "password_hash", nullable = false)
    private String password;
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "user_role",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<EntityRole> roles = new HashSet<>();
    @CreationTimestamp
    @Column(nullable = false)
    private LocalDate created;

    public void addRole(EntityRole role) {
        this.roles.add(role);
    }

    public User(String login, String password) {
        this.login = login;
        this.password = password;
    }

    public User(UUID id) {
        this.id = id;
    }

    public User() {

    }

    public User(UUID id, String login, LocalDate created) {
        this.id = id;
        this.login = login;
        this.created = created;
    }
}