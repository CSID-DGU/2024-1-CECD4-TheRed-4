package com.thered.stocksignal.jwt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.user.UserCustomDto;
import com.thered.stocksignal.app.dto.user.UserInfoDto;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import java.io.IOException;


public class AppLoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;

    //JWTUtil 주입
    private final JWTUtil jwtUtil;

    public AppLoginFilter(AuthenticationManager authenticationManager, JWTUtil jwtUtil){
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {


        try {
            ObjectMapper objectMapper = new ObjectMapper();
            UserInfoDto.LoginRequestDto loginRequest = objectMapper.readValue(request.getInputStream(), UserInfoDto.LoginRequestDto.class);

            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                    loginRequest.getEmail(),
                    loginRequest.getEmail() // 비밀번호 대신 이메일 사용
            );
            return authenticationManager.authenticate(authToken);
        } catch (IOException e) {
            throw new RuntimeException("Error reading login request", e);
        }
    }

    // 로그인 성공시 실행하는 메소드 -> 여기서 JWT가 발급됨.
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) {

        UserCustomDto userCustomDto = (UserCustomDto) authentication.getPrincipal();

        String token = jwtUtil.createJwt(userCustomDto.getUserId(), userCustomDto.getUserNickname());

        response.addHeader("Authorization", "Bearer " + token);
    }

    // 로그인 실패시 실행하는 메소드
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) {

        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        try {
            response.getWriter().write("{\"error\": \"Invalid login credentials\"}");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
