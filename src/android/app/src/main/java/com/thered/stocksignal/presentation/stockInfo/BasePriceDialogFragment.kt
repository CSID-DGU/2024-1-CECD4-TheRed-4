//package com.thered.stocksignal.Presentation.StockInfo
//
//import android.os.Bundle
//import android.view.LayoutInflater
//import android.view.View
//import android.view.ViewGroup
//import android.widget.Button
//import android.widget.EditText
//import android.widget.Toast
//import androidx.fragment.app.DialogFragment
//import com.thered.stocksignal.R
//
//open class BasePriceDialogFragment : DialogFragment() {
//
//    protected lateinit var priceInput: EditText
//
//    override fun onCreateView(
//        inflater: LayoutInflater, container: ViewGroup?,
//        savedInstanceState: Bundle?
//    ): View? {
//        val view = inflater.inflate(R.layout.dialog_buy_now, container, false)
//
//        // EditText에서 가격 입력 받기
//        priceInput = view.findViewById(R.id.price_text)
//
//        // 구매하기 버튼 설정
//        val confirmButton: Button = view.findViewById(R.id.buy_button)
//        confirmButton.setOnClickListener {
//            onConfirmButtonClick()  // 자식 클래스에서 구현된 onConfirmButtonClick 호출
//        }
//
//        // 닫기 버튼 설정
//        val cancelButton: Button = view.findViewById(R.id.close_button)
//        cancelButton.setOnClickListener {
//            dismiss()
//        }
//
//        return view
//    }
//
//    // 자식 클래스에서 오버라이드하여 구현할 메서드
//    open fun onConfirmButtonClick() {
//        // 기본적으로 가격을 입력했는지 체크하는 공통 로직을 처리할 수 있음
//        if (priceInput.text.toString().isNotEmpty()) {
//            dismiss() // 다이얼로그 닫기
//        } else {
//            // 가격을 입력하지 않으면 토스트 메시지 출력
//            Toast.makeText(activity, "구매 가격을 입력하세요.", Toast.LENGTH_SHORT).show()
//        }
//    }
//}
