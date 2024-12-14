package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CompanyRepository extends JpaRepository<Company, Long> {

    Optional<Company> findByCompanyName(String companyName);

    Optional<Company> findByCompanyCode(String companyCode);

}
