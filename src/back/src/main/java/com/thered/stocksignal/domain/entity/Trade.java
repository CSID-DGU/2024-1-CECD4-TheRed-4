package com.thered.stocksignal.domain.entity;

import com.thered.stocksignal.domain.enums.TradeType;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Builder
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Table(name = "trade")
public class Trade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @Column(nullable = false)
    private Date tradeDate;

    @Column(nullable = false)
    private Long tradePrice;

    @Column(nullable = false)
    private Long tradeQuantity;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TradeType tradeType;


}
