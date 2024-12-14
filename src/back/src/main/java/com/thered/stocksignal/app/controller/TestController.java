package com.thered.stocksignal.app.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/test")
public class TestController {

    @GetMapping("/hello")
    @Operation(summary = "배포 테스트용 API 입니다.")
    public String hello(){
        return "hello world!";
    }
}
