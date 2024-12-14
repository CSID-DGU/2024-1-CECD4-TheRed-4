package com.thered.stocksignal.service.user;

import com.thered.stocksignal.app.dto.user.UserInfoDto;
import com.thered.stocksignal.domain.entity.User;

import java.util.Optional;

public interface UserAccountService {

    Optional<User> saveKakaoUser(String email);

    Optional<User> findByEmail(String email);

    Boolean isExistNickname(String nickname);

    void editUserNickname(Long userId, String nickname);

    Optional<User> getUserById(Long userId);

    Long getUserIdFromToken(String token);

    void connectKisAccount(Long userId, UserInfoDto.kisAccountRequestDto dto);

    void editKisAccessToken(Long userId, String accessToken, String accessTokenExpired);

    void refreshKisToken(Long userId);

    void editKisSocketKey(Long userId, String socketKey, String socketKeyExpired);

    void refreshKisSocketKey(Long userId);
}
