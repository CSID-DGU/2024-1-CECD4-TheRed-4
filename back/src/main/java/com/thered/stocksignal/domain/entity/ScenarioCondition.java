package com.thered.stocksignal.domain.entity;

import com.thered.stocksignal.domain.enums.BuysellType;
import com.thered.stocksignal.domain.enums.MethodType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Builder
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Table(name = "scenario_condition")
public class ScenarioCondition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(cascade = CascadeType.REMOVE)
    @JoinColumn(name = "scenario_id", nullable = false)
    private Scenario scenario;

    @Enumerated(EnumType.STRING)
    @Column(name = "buysell_type", nullable = false)
    private BuysellType buysellType;

    @Enumerated(EnumType.STRING)
    @Column(name = "method_type", nullable = false)
    private MethodType methodType;

    @Column(name = "target_price1")
    private Long targetPrice1;

    @Column(name = "target_price2")
    private Long targetPrice2;

    @Column(name = "target_price3")
    private Long targetPrice3;

    @Column(name = "target_price4")
    private Long targetPrice4;

    @Column(name = "quantity", nullable = false)
    private Long quantity;

    @Setter
    @Column(name = "is_price1_reached", nullable = false)
    private boolean isPrice1Reached;

    @Setter
    @Column(name = "is_price3_reached", nullable = false)
    private boolean isPrice3Reached;

}
