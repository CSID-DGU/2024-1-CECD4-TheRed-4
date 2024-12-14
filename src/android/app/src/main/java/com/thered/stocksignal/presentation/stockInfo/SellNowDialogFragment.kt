package com.thered.stocksignal.presentation.stockinfo

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.fragment.app.DialogFragment
import com.thered.stocksignal.R

class SellNowDialogFragment : DialogFragment() {
    private lateinit var sell_price_text: EditText
    private lateinit var sell_quantity_hint: EditText
    private var onConfirmClickListenerSell: ((String, String) -> Unit)? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        dialog?.window?.setLayout((resources.displayMetrics.widthPixels * 1).toInt(), ViewGroup.LayoutParams.WRAP_CONTENT)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.dialog_sell_now, container, false)

        // EditText 초기화
        sell_price_text = view.findViewById(R.id.sell_price_text)
        sell_quantity_hint = view.findViewById(R.id.sell_quantity_hint)

        // 판매하기 버튼 클릭 시
        val confirmButton: Button? = view.findViewById(R.id.sell_button)
        confirmButton?.setOnClickListener {
            val price = sell_price_text.text.toString()
            val quantity = sell_quantity_hint.text.toString()

            if (price.isNotEmpty() && quantity.isNotEmpty()) {
                onConfirmClickListenerSell?.invoke(price, quantity) // 가격과 수량을 전달
                dismiss()  // 다이얼로그 닫기
            } else {
                Toast.makeText(activity, "가격과 수량을 입력하세요.", Toast.LENGTH_SHORT).show()
            }
        }

        // 닫기 버튼 클릭 시
        val cancelButton: Button = view.findViewById(R.id.close_button)
        cancelButton.setOnClickListener {
            dismiss()
        }

        val buyButton: Button = view.findViewById(R.id.sell_buy_change_button)
        buyButton.setOnClickListener {
            val sellDialog = BuyNowDialogFragment()
            sellDialog.show(requireFragmentManager(), "BuyNowDialog")
            dismiss()  // 현재 다이얼로그는 닫기
        }
        return view
    }
    fun setOnConfirmClickListenerSell(listener: (String, String) -> Unit) {
        this.onConfirmClickListenerSell = listener
    }
}
