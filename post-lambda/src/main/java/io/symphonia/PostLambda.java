package io.symphonia;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

public class PostLambda {

    private ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    private DynamoDB dynamoDB = new DynamoDB(AmazonDynamoDBClientBuilder.defaultClient());
    private String tableName = System.getenv("TABLE");

    public ApiGatewayProxyResponse handler(ApiGatewayProxyRequest request) throws IOException {
        Data data = objectMapper.readValue(request.body, Data.class);

        Table table = dynamoDB.getTable(tableName);
        Item item = new Item()
                .withPrimaryKey("primaryKey", data.primaryKey)
                .withString("content", data.content);
        table.putItem(item);

        return new ApiGatewayProxyResponse(200, data.primaryKey);
    }

    public static class Data {
        public String primaryKey;
        public String content;
    }

    public static class ApiGatewayProxyRequest {
        public String body;
    }

    public static class ApiGatewayProxyResponse {
        public Integer statusCode;
        public String body;

        public ApiGatewayProxyResponse() {
        }

        public ApiGatewayProxyResponse(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
    }
}
