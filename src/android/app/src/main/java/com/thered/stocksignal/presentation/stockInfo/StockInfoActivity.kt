    package com.thered.stocksignal.presentation.stockinfo

    import android.content.Intent
    import android.os.Bundle
    import android.widget.Button
    import android.widget.TextView
    import android.widget.ImageView
    import androidx.appcompat.app.AppCompatActivity
    import android.content.res.ColorStateList
    import android.graphics.Color
    import android.util.Log
    import android.widget.Toast
    import androidx.activity.viewModels
    import androidx.fragment.app.Fragment
    import androidx.fragment.app.FragmentManager
    import androidx.fragment.app.FragmentTransaction
    import com.bumptech.glide.Glide
    import com.thered.stocksignal.Data.Network.CompanyApiService
    import com.thered.stocksignal.Data.model.CompanyResponse
    import retrofit2.Call
    import retrofit2.Callback
    import retrofit2.Response
    import retrofit2.Retrofit
    import retrofit2.converter.gson.GsonConverterFactory
    import com.thered.stocksignal.R
    import com.github.mikephil.charting.charts.LineChart
    import com.thered.stocksignal.BuildConfig
    import com.thered.stocksignal.Data.Network.BuyRequest
    import com.thered.stocksignal.Data.Network.BuyResponse
    import com.thered.stocksignal.Data.Network.BuyTradeApiService
    import com.thered.stocksignal.Data.Network.SellRequest
    import com.thered.stocksignal.Data.Network.SellResponse
    import com.thered.stocksignal.Data.Network.SellTradeApiService
    import com.thered.stocksignal.presentation.main.MainActivity
    import com.thered.stocksignal.presentation.newScenario.NewScenarioActivity
    import com.thered.stocksignal.presentation.newScenario.NewScenarioViewModel

    class StockInfoActivity : AppCompatActivity() {
        private lateinit var companyNameTextView: TextView // 회사명
        private lateinit var profitRateTextView: TextView // 수익률
        private var itemImgUrl: String? = null // 사진 url
        private lateinit var newsButton: Button
        private lateinit var analysisButton: Button
        private lateinit var aiButton: Button
        private lateinit var autoTradeButton: Button
        private lateinit var sellNowButton: Button
        private lateinit var apiService: CompanyApiService
        private lateinit var buytradeApiService: BuyTradeApiService
        private lateinit var selltradeApiService: SellTradeApiService
        private val token = BuildConfig.API_TOKEN // API 토큰
        private lateinit var tradeButton: Button
        private lateinit var lineChart: LineChart
        private val newScenarioViewModel: NewScenarioViewModel by viewModels()

        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)
            setContentView(R.layout.activity_stock_info)
            companyNameTextView = findViewById(R.id.company_name_text_view)
            profitRateTextView = findViewById(R.id.profit_rate)
            lineChart = findViewById(R.id.line_chart) // XML에서 LineChart를 찾음
            val dataList = newScenarioViewModel.loadChartData() // ViewModel에서 데이터 로드
            val lineData = newScenarioViewModel.setupChartData(dataList) // ViewModel에서 차트 데이터 설정
            // 차트 데이터 설정
            lineChart.data = lineData
            lineChart.setVisibleXRangeMaximum(100f)
            lineChart.animateX(1500)
            lineChart.description.isEnabled = false
            lineChart.invalidate()

            // Intent에서 값 가져오기
            val companyName: String = intent.getStringExtra("company_name") ?: "기본 이름"
            val itemPrice: String = intent.getStringExtra("stock_price") ?: "기본 가격"
            val itemEarnRate: String = intent.getStringExtra("earn_rate") ?: "기본 수익률"
            itemImgUrl = intent.getStringExtra("image_url") ?: "기본 이미지 URL"
            // 데이터 출력 확인
            Log.d(
                "넘어온 데이터 값",
                "Name: $companyName, Price: $itemPrice, EarnRate: $itemEarnRate, ImageURL: $itemImgUrl"
            )
            val fragment = AnalysisFragment().apply {
                arguments=Bundle().apply {
                    putString("company_name",companyName)
                }
            }
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .commit()
            // 회사 이름 텍스트 설정
            companyNameTextView.text = companyName
            Log.d("회사 이름", "Name: $companyName")
            // 수익률 텍스트 설정 & 색상 변경
            profitRateTextView.text = itemEarnRate // 수정된 부분
            Log.d("수익률", "EarnRate: $itemEarnRate")

            if (itemEarnRate.startsWith("+")) {
                // +가 붙어 있으면 빨간색
                profitRateTextView.setTextColor(Color.parseColor("#FF5353"))  // 빨간색
            } else if (itemEarnRate.startsWith("-")) {
                // -가 붙어 있으면 파란색
                profitRateTextView.setTextColor(Color.parseColor("#0080FF"))  // 파란색
            } else {
                // 기본 색상 (수익률이 0일 때 등)
                profitRateTextView.setTextColor(Color.parseColor("#333333"))  // 회색
            }
            // Retrofit 초기화
            val retrofit = Retrofit.Builder()
                .baseUrl("https://pposiraun.com/") // API의 실제 URL로 변경
                .addConverterFactory(GsonConverterFactory.create())
                .build()
            apiService = retrofit.create(CompanyApiService::class.java)
            buytradeApiService = retrofit.create(BuyTradeApiService::class.java)
            selltradeApiService = retrofit.create(SellTradeApiService::class.java)
            // 로고 가져오기 메서드 호출
            getCompanyLogo(companyName)
            // UI 요소 초기화
            newsButton = findViewById(R.id.button1)
            analysisButton = findViewById(R.id.button2)
            aiButton = findViewById(R.id.button3)
            autoTradeButton = findViewById(R.id.button4)
            sellNowButton = findViewById(R.id.sellButton)
            // 즉시 거래하기 버튼 클릭 리스너 추가
            sellNowButton.setOnClickListener {
                showbuyDialog() // 버튼 클릭 시 다이얼로그 표시
            }
            tradeButton = findViewById(R.id.buyButton) // 레이아웃에 버튼 ID 맞추기
            // 버튼 클릭 리스너 설정
            tradeButton.setOnClickListener {
                // TradeActivity로 이동하는 Intent 생성
                val intent = Intent(this, SelectTradeActivity::class.java)
                startActivity(intent)
            }
            // 기본 분석 Fragment 로드
            if (savedInstanceState == null) {
                val bundle = Bundle()
                bundle.putString("company_name",companyName)
                val fragment = AnalysisFragment()
                fragment.arguments = bundle  // Bundle을 fragment에 전달
                switchFragment(AnalysisFragment())
                analysisButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF"))
                analysisButton.setTextColor(Color.WHITE)
            }
            // 버튼 클릭 리스너 설정
            newsButton.setOnClickListener {
                val bundle = Bundle()
                bundle.putString("company_name", companyName) // 회사명을 Bundle에 추가
                val fragment = NewsFragment() // NewsFragment 인스턴스 생성
                fragment.arguments = bundle // Fragment에 Bundle 설정
                switchFragment(fragment) // Fragment 교체
                resetButtonColors() // 버튼 색상 초기화
                newsButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF")) // 선택된 버튼 색상 변경
                newsButton.setTextColor(Color.WHITE)
            }
            aiButton.setOnClickListener {
                switchFragment(PredictionFragment())
                resetButtonColors()
                aiButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF"))
                aiButton.setTextColor(Color.WHITE)
            }
            analysisButton.setOnClickListener {
                val bundle = Bundle()
                bundle.putString("company_name", companyName)
                val fragment = AnalysisFragment()
                fragment.arguments = bundle
                switchFragment(fragment)
                resetButtonColors()
                analysisButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF"))
                analysisButton.setTextColor(Color.WHITE)

                Log.d("분석 전달", "companyName 전달: $companyName")
            }
//            autoTradeButton.setOnClickListener {
//                // NewScenarioActivity로 이동
//                val intent = Intent(this, NewScenarioActivity::class.java)
//                startActivity(intent)
//                // 버튼 색상 변경
//                resetButtonColors()
//                autoTradeButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF"))
//                autoTradeButton.setTextColor(Color.WHITE)
//            }
            autoTradeButton.setOnClickListener {
                switchFragment(AutoTradeFragment())
                resetButtonColors()
                autoTradeButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#0080FF"))
                autoTradeButton.setTextColor(Color.WHITE)
            }

        }
        // 프래그먼트 변경
        private fun switchFragment(fragment: Fragment) {
            val fragmentManager: FragmentManager = supportFragmentManager
            val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()
            fragmentTransaction.replace(R.id.fragment_container, fragment)
            fragmentTransaction.addToBackStack(null)
            fragmentTransaction.commit()
        }
        // 버튼 클릭 시, 색상 변화
        private fun resetButtonColors() {
            newsButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#FFFFFF"))
            newsButton.setTextColor(Color.BLACK)
            aiButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#FFFFFF"))
            aiButton.setTextColor(Color.BLACK)
            analysisButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#FFFFFF"))
            analysisButton.setTextColor(Color.BLACK)
            autoTradeButton.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#FFFFFF"))
            autoTradeButton.setTextColor(Color.BLACK)
        }
        // 뒤로가기 했을 때 메인으로 이동하게 하기
        override fun onBackPressed() {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
            finish()
            super.onBackPressed()
        }
        // 로고 이미지 불러오기 -> 완료
        private fun getCompanyLogo(companyName: String) {
            apiService.getCompanyLogo(companyName).enqueue(object : Callback<CompanyResponse> {
                override fun onResponse(call: Call<CompanyResponse>, response: Response<CompanyResponse>) {
                    if (response.isSuccessful && response.body() != null) {
                        val logoImageId = response.body()?.data?.logoImage // API 응답의 logoImage 값
                        if (logoImageId != null) {
                            // Google Drive URL 생성
                            val logoUrl = "https://drive.google.com/thumbnail?id=$logoImageId"
                            Log.d("Logo URL", "Generated URL: $logoUrl") // 생성된 URL 로그 확인
                            // 이미지 로드
                            val companyLogoImageView: ImageView = findViewById(R.id.companyLogo)
                            Glide.with(this@StockInfoActivity)
                                .load(logoUrl)
                                .placeholder(R.drawable.logo_title) // 로딩 중 이미지
                                .error(R.drawable.samsung) // 로드 실패 시 이미지
                                .into(companyLogoImageView)
                        } else {
                            Log.e("Logo Error", "logoImage ID가 null입니다.")
                            companyNameTextView.text = "회사 로고를 가져오는 데 실패했습니다."
                        }
                    } else {
                        Log.e("API Error", "Response Code: ${response.code()}, Message: ${response.message()}")
                        companyNameTextView.text = "회사 로고 조회에 실패했습니다."
                    }
                }
                override fun onFailure(call: Call<CompanyResponse>, t: Throwable) {
                    Log.e("Network Error", "회사 로고 조회 중 오류 발생: ${t.message}")
                    companyNameTextView.text = "네트워크 오류가 발생했습니다."
                }
            })
        }
        private fun showbuyDialog() {
            val dialog = BuyNowDialogFragment()
            // 확인 버튼 클릭 시 가격과 수량을 받아서 처리
            dialog.setOnConfirmClickListener { price, quantity ->
                performTradeBuy(price, quantity)
            }
            dialog.show(supportFragmentManager, "BuyNowDialog")
        }
        private fun performTradeBuy(price: String, quantity: String) {
            val scode = "005930"  // 종목 코드 (예: 삼성전자)
            val price = price.toIntOrNull() ?: 0
            val week = quantity.toIntOrNull() ?: 0
            val orderType = "JIJUNG"
            // 로그를 찍어서 price와 quantity 값 확인
            Log.d("서버 전송 전 데이터 확인", "Price: $price, Quantity: $week, Stock Code: $scode, orderType : $orderType, Authorization Header: $token")

            if (price > 0 && week > 0) {
                val buyRequest =
                    BuyRequest(scode = scode, price = price, week = week, orderType = orderType)
                val token = "Bearer $token"
                // 백엔드 API 호출
                buytradeApiService.buyStock(token, buyRequest)
                    .enqueue(object : Callback<BuyResponse> {
                        override fun onResponse(
                            call: Call<BuyResponse>,
                            response: Response<BuyResponse>
                        ) {
                            if (response.isSuccessful) {
                                val result = response.body()
                                if (result != null && result.result == "SUCCESS") {
                                    Log.d("TradeRequest", "SUCCESS: ${result.message}")
                                } else {
                                    // 실패 메시지 출력
                                    val failureMessage = result?.message ?: "알 수 없는 오류"
                                    Log.e("TradeRequest", "failureMessage: $failureMessage")
                                }
                            } else {
                                // 실패 시 상태 코드와 메시지 출력
                                val errorMessage = response.errorBody()?.string() ?: "서버 오류 발생"
                                Log.e("TradeRequest", "failureMessage: $errorMessage")
                            }
                        }
                        override fun onFailure(call: Call<BuyResponse>, t: Throwable) {
                            Log.e("TradeRequest", "Network Error: ${t.message}")
                        }
                    })
            } else {
                Log.e("TradeRequest", "유효한 가격과 수량을 입력하세요.")
            }
        }




        private fun showsellDialog() {
            val dialog = SellNowDialogFragment()
            // 확인 버튼 클릭 시 가격과 수량을 받아서 처리
            dialog.setOnConfirmClickListenerSell { price, quantity ->
                performTradeSell(price, quantity)
            }
            dialog.show(supportFragmentManager, "SellNowDialog")
        }

        private fun performTradeSell(price: String, quantity: String) {
            val scode = "005930"  // 종목 코드 (예: 삼성전자)
            val price = price.toIntOrNull() ?: 0
            val week = quantity.toIntOrNull() ?: 0

            if (price == null || week == null || price <= 0 || week <= 0) {
                Log.e("TradeRequest", "유효한 가격과 수량을 입력하세요.")
                return
            }

            val orderType = "JIJUNG"
            if (price > 0 && week > 0) {
                val sellRequest =
                    SellRequest(scode = scode, price = price, week = week, orderType = orderType)
                val token = "Bearer $token"
                // 백엔드 API 호출
                selltradeApiService.sellStock("Bearer $token", sellRequest)
                    .enqueue(object : Callback<SellResponse> {
                        override fun onResponse(
                            call: Call<SellResponse>,
                            response: Response<SellResponse>
                        ) {
                            if (response.isSuccessful) {
                                val result = response.body()
                                if (result != null && result.result == "SUCCESS") {
                                    Log.d("TradeRequest", "SUCCESS: ${result.message}")
                                    Toast.makeText(applicationContext, "주문 성공", Toast.LENGTH_SHORT).show()  // 성공 메시지
                                } else {
                                    // 실패 메시지 출력
                                    val failureMessage = result?.message ?: "알 수 없는 오류"
                                    Log.e("TradeRequest", "failureMessage: $failureMessage")
                                    Toast.makeText(applicationContext, failureMessage, Toast.LENGTH_SHORT).show()  // 실패 메시지
                                }
                            } else {
                                // 실패 시 상태 코드와 메시지 출력
                                val errorMessage = response.errorBody()?.string() ?: "서버 오류 발생"
                                Log.e("TradeRequest", "failureMessage: $errorMessage")
                                Toast.makeText(applicationContext, errorMessage, Toast.LENGTH_SHORT).show()  // 실패 메시지
                            }
                        }
                        override fun onFailure(call: Call<SellResponse>, t: Throwable) {
                            Log.e("TradeRequest", "Network Error: ${t.message}")
                            Toast.makeText(applicationContext, "네트워크 오류: ${t.message}", Toast.LENGTH_SHORT).show()
                        }
                    })
            } else {
                Log.e("TradeRequest", "유효한 가격과 수량을 입력하세요.")
            }
        }
    }