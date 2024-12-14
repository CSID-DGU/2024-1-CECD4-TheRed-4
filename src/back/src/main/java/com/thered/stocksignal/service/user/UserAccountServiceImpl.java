package com.thered.stocksignal.service.user;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thered.stocksignal.app.dto.kis.KisAccountDto;
import com.thered.stocksignal.app.dto.user.UserInfoDto;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.domain.enums.OauthType;
import com.thered.stocksignal.jwt.JWTUtil;
import com.thered.stocksignal.repository.UserRepository;
import com.thered.stocksignal.util.DateUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
@RequiredArgsConstructor
@Transactional
public class UserAccountServiceImpl implements UserAccountService{

    private final UserRepository userRepository;
    private final JWTUtil jwtUtil;
    private static final String baseUrl = "https://openapivts.koreainvestment.com:29443";

    @Override
    public Optional<User> saveKakaoUser(String email) {
        User newUser = User.builder()
                .email(email)
                .nickname(email)
                .oauthType(OauthType.KAKAO)
                .isKisLinked(false)
                .build();
        Optional<User> user = Optional.of(userRepository.save(newUser));
        return user;
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public Boolean isExistNickname(String nickname) {
        return userRepository.existsByNickname(nickname);

    }

    @Override
    public void editUserNickname(Long userId, String nickname) {
        Optional<User> user = userRepository.findById(userId);
        if(user == null) throw new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId);
        User updateUser = user.get();
        updateUser.setNickname(nickname);
        userRepository.save(updateUser);
    }

    @Override
    public Optional<User> getUserById(Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if(user.isEmpty()) throw new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId);
        return user;
    }

    @Override
    public Long getUserIdFromToken(String token) {
        if (token == null || !token.startsWith("Bearer ")) return -1L;

        String actualToken = token.replace("Bearer ", "");
        Long userId = jwtUtil.getUserId(actualToken);

        return userId;
    }

    @Override
    public void connectKisAccount(Long userId, UserInfoDto.kisAccountRequestDto dto) {
        Optional<User> user = userRepository.findById(userId);
        if(user.isEmpty()) throw new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId);
        User updateUser = user.get();

        updateUser.setKisAccount(dto.getSecretKey(), dto.getAppKey(), dto.getAccount(), true);

        userRepository.save(updateUser);
    }

    @Override
    public void editKisAccessToken(Long userId, String accessToken, String accessTokenExpired) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId));
        user.setAccessToken(accessToken, accessTokenExpired);
        userRepository.save(user);
    }

    @Override
    public void refreshKisToken(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId));

        if(user.getIsKisLinked() == false) throw new RuntimeException("한국투자증권 연동이 되어 있지 않습니다.");

        Date expirationDate;
        if (user.getKisTokenExpired() != null) expirationDate = DateUtil.parseDate(user.getKisTokenExpired());
        else expirationDate = new Date(0);
        Date now = new Date();

        // 유효기간이 만료되지 않은 경우
        if(!expirationDate.before(now)) return;

        // 유효기간이 만료된 경우
        RestTemplate tokenRt = new RestTemplate();
        Map<String, String> params = new HashMap<>();
        params.put("grant_type", "client_credentials");
        params.put("appkey", user.getAppKey());
        params.put("appsecret", user.getSecretKey());
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonParams;
        try {
            jsonParams = objectMapper.writeValueAsString(params); // JSON으로 변환
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }
        HttpEntity<String> request = new HttpEntity<>(jsonParams);

        ResponseEntity<String> response = tokenRt.exchange(
                baseUrl+"/oauth2/tokenP",
                HttpMethod.POST,
                request,
                String.class
        ); // Request to Kis

        KisAccountDto.AccessTokenResponseDto tokenResponseDto;

        try{
            tokenResponseDto = objectMapper.readValue(response.getBody(), KisAccountDto.AccessTokenResponseDto.class);
            String newAccessToken = tokenResponseDto.getAccess_token();

            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.HOUR, 15);    // utc시간차 고려

            String newTokenExpired = DateUtil.formatDate(calendar.getTime());

            editKisAccessToken(user.getId(), newAccessToken, newTokenExpired);
        }catch(JsonMappingException e){
            e.printStackTrace();
        }catch (JsonProcessingException e){
            e.printStackTrace();
        }
    }

    @Override
    public void editKisSocketKey(Long userId, String socketKey, String socketKeyExpired) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId));
        user.setSocketKey(socketKey, socketKeyExpired);
        userRepository.save(user);
    }

    @Override
    public void refreshKisSocketKey(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 userId 입니다 : " + userId));

        if(user.getIsKisLinked() == false) throw new RuntimeException("한국투자증권 연동이 되어 있지 않습니다.");

        Date expirationDate;
        if (user.getSocketKey() != null) expirationDate = DateUtil.parseDate(user.getSocketKeyExpired());
        else expirationDate = new Date(0);
        Date now = new Date();

        // 유효기간이 만료되지 않은 경우
        if(!expirationDate.before(now)) return;

        // 유효기간이 만료된 경우
        RestTemplate tokenRt = new RestTemplate();
        Map<String, String> params = new HashMap<>();
        params.put("grant_type", "client_credentials");
        params.put("appkey", user.getAppKey());
        params.put("secretkey", user.getSecretKey());
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonParams;
        try {
            jsonParams = objectMapper.writeValueAsString(params); // JSON으로 변환
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 오류", e);
        }
        HttpEntity<String> request = new HttpEntity<>(jsonParams);

        ResponseEntity<String> response = tokenRt.exchange(
                baseUrl+"/oauth2/Approval",
                HttpMethod.POST,
                request,
                String.class
        ); // Request to Kis

        KisAccountDto.SocketKeyResponseDto socketKeyResponseDto;

        try{
            socketKeyResponseDto = objectMapper.readValue(response.getBody(), KisAccountDto.SocketKeyResponseDto.class);
            String newSocketKey = socketKeyResponseDto.getApproval_key();

            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.HOUR, 15);    // utc시간차 고려

            String newSocketKeyExpired = DateUtil.formatDate(calendar.getTime());

            editKisSocketKey(user.getId(), newSocketKey, newSocketKeyExpired);
        }catch(JsonMappingException e){
            e.printStackTrace();
        }catch (JsonProcessingException e){
            e.printStackTrace();
        }
    }

}
