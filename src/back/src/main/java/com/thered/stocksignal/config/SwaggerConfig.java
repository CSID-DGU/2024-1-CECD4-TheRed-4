package com.thered.stocksignal.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.servers.Server;

import java.util.List;


@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI openAPI(){
        Info info = new Info()
                .title("StockSignal API Document")
                .version("v0.0.1")
                .description("StockSignal API 명세서입니다.");

        Server httpServer = new Server()
                .url("http://localhost:8080")
                .description("HTTP server");

        Server httpServer2 = new Server()
                .url("http://pposiraun.com")
                .description("HTTP server");

        Server httpsServer = new Server()
                .url("https://pposiraun.com")
                .description("HTTPS server");

        SecurityScheme securityScheme = new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .name("Authorization");

        SecurityRequirement securityRequirement = new SecurityRequirement().addList("BearerAuth");

        return new OpenAPI()
                .components(new Components().addSecuritySchemes("BearerAuth", securityScheme))
                .info(info)
                .addSecurityItem(securityRequirement)
                .servers(List.of(httpServer, httpServer2, httpsServer));
    }
}
