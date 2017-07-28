package io.symphonia;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.Map;

public class GetLambda {

    private ObjectMapper objectMapper = new ObjectMapper();

    private AmazonDynamoDB amazonDynamoDB = AmazonDynamoDBClientBuilder.defaultClient();
    private String tableName = System.getenv("TABLE");

    public ApiGatewayProxyResponse handler(ApiGatewayProxyRequest request) throws IOException {

        String primaryKey = request.body;

        // DynamoDB fetch

        String json = "";
        // String json = objectMapper.writeValueAsString(featureCollection);

        return new ApiGatewayProxyResponse(200, json);
    }

    public static class ApiGatewayProxyRequest {
        public String body;
        public Map<String, String> queryStringParameters;
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
