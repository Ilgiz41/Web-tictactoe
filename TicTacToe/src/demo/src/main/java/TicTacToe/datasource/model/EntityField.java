package TicTacToe.datasource.model;

import jakarta.persistence.Convert;
import jakarta.persistence.Embeddable;
import lombok.Data;

@Embeddable
@Data
public class EntityField {
    @Convert(converter = TicTacToe.datasource.converter.Converter.class)
    private int[][] field;

    public EntityField() {
        field = new int[3][3];
    }
}
