package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CompanyRepository extends JpaRepository<Company, Long> {

    Company findByCompanyName(String companyName);

}
