package com.thered.stocksignal.domain.entity;

import com.thered.stocksignal.domain.enums.OauthType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 256)
    private String email;

    @Column(nullable = false, length = 256)
    private String nickname;

    @Enumerated(EnumType.STRING)
    @Column(nullable = true)
    private OauthType oauthType;

    @Column(nullable = true, length = 256)
    private String oauthId;

    @Column(nullable = true, length = 256)
    private String secretKey;

    @Column(nullable = true, length = 256)
    private String appKey;

    @Column(nullable = true)
    private Boolean isKisLinked;

    @Column(nullable = true)
    private String accountNumber;

    @Column(nullable = true, length = 2048)
    private String kisToken;

    @Column(nullable = true, length = 2048)
    private String kisTokenExpired;

    @Column(nullable = true, length = 2048)
    private String socketKey;

    @Column(nullable = true, length = 2048)
    private String socketKeyExpired;

    public void setNickname(String nickname) {this.nickname = nickname;}

    public void setKisAccount(String secretKey, String appKey, String accountNumber, Boolean isKisLinked){
        this.secretKey = secretKey;
        this.appKey = appKey;
        this.accountNumber = accountNumber;
        this.isKisLinked = isKisLinked;
    }

    public void setAccessToken(String kisToken, String kisTokenExpired){
        this.kisToken = kisToken;
        this.kisTokenExpired = kisTokenExpired;
    }

    public void setSocketKey(String socketKey, String socketKeyExpired){
        this.socketKey = socketKey;
        this.socketKeyExpired = socketKeyExpired;
    }
}
