package com.thered.stocksignal.service.scenario;


import com.thered.stocksignal.app.dto.ScenarioDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ConditionResponseDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioRequestDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioResponseDto;
import com.thered.stocksignal.websocket.WebSocketHandler;
import com.thered.stocksignal.domain.entity.Company;
import com.thered.stocksignal.domain.entity.Scenario;
import com.thered.stocksignal.domain.entity.ScenarioCondition;
import com.thered.stocksignal.domain.entity.User;
import com.thered.stocksignal.repository.CompanyRepository;
import com.thered.stocksignal.repository.ScenarioConditionRepository;
import com.thered.stocksignal.repository.ScenarioRepository;
import com.thered.stocksignal.repository.UserRepository;
import com.thered.stocksignal.service.company.CompanyService;
import com.thered.stocksignal.service.trade.TradeService;
import com.thered.stocksignal.service.user.UserAccountService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class ScenarioServiceImpl implements ScenarioService {

    private final ScenarioRepository scenarioRepository;
    private final CompanyService companyService;
    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final ScenarioConditionRepository scenarioConditionRepository;
    private final WebSocketHandler webSocketHandler;
    private final UserAccountService userAccountService;
    private final TradeService tradeService;

    public List<ScenarioResponseDto> getScenario(Long userId) {
        List<Scenario> scenarios = scenarioRepository.findByUserId(userId);

        List<ScenarioResponseDto> scenarioList = new ArrayList<>();

        for (Scenario scenario : scenarios) {
            Long currentPrice = companyService.getCurrentPriceByCode(scenario.getCompany().getCompanyCode(), userId)
                    .getCurrentPrice();

            ScenarioResponseDto responseDto = ScenarioResponseDto.builder()
                    .scenarioId(scenario.getId())
                    .scenarioName(scenario.getScenarioName())
                    .companyName(scenario.getCompany().getCompanyName())
                    .initialPrice(scenario.getInitialPrice())
                    .currentPrice(currentPrice)
                    .build();

            scenarioList.add(responseDto);
        }

        return scenarioList;
    }

    public boolean createScenario(String token, Long userId, ScenarioRequestDto newScenario) {

        String companyName = newScenario.getCompanyName();
        Optional<Company> company = companyRepository.findByCompanyName(companyName);
        Optional<User> user = userAccountService.getUserById(userId);

        if(company.isEmpty()) throw new EntityNotFoundException("회사 정보가 없습니다. : "+companyName);

        List<Scenario> scenarios = scenarioRepository.findByUserId(userId);
        for(Scenario scenario : scenarios) {
            if(scenario.getCompany().getCompanyName().equals(companyName)){
                return false;   // 종목당 시나리오는 최대 하나
            }
        }

        userAccountService.refreshKisSocketKey(userId);

        String companyCode = company.get().getCompanyCode();
        webSocketHandler.handleKisSocketRequest(token, userId, companyCode, null, "1");

        // 시나리오 객체 생성
        Scenario scenario = Scenario.builder()
                .scenarioName(newScenario.getScenarioName())
                .company(company.get())
                .initialPrice(newScenario.getInitialPrice())
                .user(user.get())
                .build();

        // 시나리오 저장
        scenario = scenarioRepository.save(scenario);

        // 조건 객체 생성
        ScenarioCondition condition = ScenarioCondition.builder()
                .scenario(scenario)
                .buysellType(newScenario.getBuysellType())
                .methodType(newScenario.getMethodType())
                .targetPrice1(newScenario.getTargetPrice1())
                .targetPrice2(newScenario.getTargetPrice2())
                .targetPrice3(newScenario.getTargetPrice3())
                .targetPrice4(newScenario.getTargetPrice4())
                .quantity(newScenario.getQuantity())
                .build();

        // 조건 저장
        scenarioConditionRepository.save(condition);

        return true;
    }

    public boolean deleteScenario(String token, Long userId, Long scenarioId) {

        Optional<Scenario> scenario = scenarioRepository.findByIdAndUserId(scenarioId, userId);

        // 시나리오가 존재하지 않으면 삭제 실패
        if (scenario.isEmpty()) {
            return false;
        }

        String companyCode = scenario.get().getCompany().getCompanyCode();

        // 시나리오와 관련된 조건 삭제
        scenarioConditionRepository.deleteByScenario(scenario.get());

        // 시나리오 삭제
        scenarioRepository.delete(scenario.get());

        userAccountService.refreshKisSocketKey(userId);

        webSocketHandler.handleKisSocketRequest(token, userId, companyCode, null, "2");

        return true;
    }

    public List<ConditionResponseDto> getConditions(Long userId, Long scenarioId) {

        List<ScenarioCondition> conditions = scenarioConditionRepository.findByScenarioId(scenarioId);

        List<ConditionResponseDto> conditionList = new ArrayList<>();

        for (ScenarioCondition condition : conditions) {
            Long currentPrice = companyService.getCurrentPriceByCode(condition.getScenario().getCompany().getCompanyCode(), userId)
                    .getCurrentPrice();

            ConditionResponseDto responseDto = ConditionResponseDto.builder()
                    .conditionId(condition.getId())
                    .buysellType(condition.getBuysellType())
                    .methodType(condition.getMethodType())
                    .initialPrice(condition.getScenario().getInitialPrice())
                    .currentPrice(currentPrice)
                    .targetPrice1(condition.getTargetPrice1())
                    .targetPrice2(condition.getTargetPrice2())
                    .targetPrice3(condition.getTargetPrice3())
                    .targetPrice4(condition.getTargetPrice4())
                    .quantity(condition.getQuantity())
                    .build();

            conditionList.add(responseDto);
        }

        return conditionList;
    }

    public boolean addCondition(Long userId, ScenarioDto.ConditionRequestDto newCondition){
        Long scenarioId = newCondition.getScenarioId();
        Optional<Scenario> scenario = scenarioRepository.findById(scenarioId);

        if(scenario.isEmpty()) return false;

        List<ScenarioCondition> conditions = scenarioConditionRepository.findByScenarioId(scenarioId);
        for(ScenarioCondition condition : conditions){
            if(newCondition.getBuysellType() == condition.getBuysellType()){
                return false;   // buy 혹은 sell은 시나리오당 최대 한개
            }
        }

        // 조건 객체 생성
        ScenarioCondition condition = ScenarioCondition.builder()
                .scenario(scenario.get())
                .buysellType(newCondition.getBuysellType())
                .methodType(newCondition.getMethodType())
                .targetPrice1(newCondition.getTargetPrice1())
                .targetPrice2(newCondition.getTargetPrice2())
                .targetPrice3(newCondition.getTargetPrice3())
                .targetPrice4(newCondition.getTargetPrice4())
                .quantity(newCondition.getQuantity())
                .build();

        // 조건 저장
        scenarioConditionRepository.save(condition);

        return true;
    }

    public boolean deleteCondition(Long userId, Long conditionId) {

        Optional<ScenarioCondition> condition = scenarioConditionRepository.findById(conditionId);

        // 조건이 존재하지 않으면 삭제 실패
        if (condition.isEmpty()) {
            return false;
        }

        // 해당 조건이 사용자의 것이 아니면 삭제 실패
        if(!Objects.equals(condition.get().getScenario().getUser().getId(), userId)){
            return false;
        }

        // 조건 삭제
        scenarioConditionRepository.delete(condition.get());

        return true;
    }
}
