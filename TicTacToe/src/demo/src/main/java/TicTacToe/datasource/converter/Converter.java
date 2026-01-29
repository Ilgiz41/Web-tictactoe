package TicTacToe.datasource.converter;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;

@jakarta.persistence.Converter

public class Converter implements AttributeConverter<int[][], String> {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String convertToDatabaseColumn(int[][] attribute) {
        if (attribute == null) {
            return null;
        }
        try {
            return objectMapper.writeValueAsString(attribute);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Ошибка при преобразовании int[][] в JSON строку", e);
        }
    }

    @Override
    public int[][] convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.trim().isEmpty()) {
            return null;
        }
        try {
            return objectMapper.readValue(dbData, int[][].class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Ошибка при преобразовании JSON строки в int[][]", e);
        }
    }
}
