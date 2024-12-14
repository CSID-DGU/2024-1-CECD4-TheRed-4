package com.thered.stocksignal.Data.model

data class TokenResponse(
    val code: String,      // 응답 코드 (예: "200", "400" 등)
    val result: String,    // 결과 상태 (예: "success", "error" 등)
    val message: String,   // 메시지 (오류 메시지 또는 성공 메시지)
    val data: Data?        // 실제 데이터 (null 가능)
)

data class Data(
    val token: String?,    // 액세스 토큰 (null 가능)
    val userId: String?    // 사용자 ID (null 가능)
)
