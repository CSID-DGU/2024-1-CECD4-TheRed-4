package com.thered.stocksignal.domain.entity;

import com.thered.stocksignal.domain.enums.OauthType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
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
}