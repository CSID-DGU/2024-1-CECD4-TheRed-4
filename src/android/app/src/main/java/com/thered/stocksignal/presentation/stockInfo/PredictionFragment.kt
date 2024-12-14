package com.thered.stocksignal.presentation.stockinfo

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import android.widget.ImageView
import com.thered.stocksignal.R

class PredictionFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_prediction, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val predictionImage: ImageView = view.findViewById(R.id.predictionImage)
        predictionImage.setImageResource(R.drawable.ai_example) // AI 예측 이미지 설정
    }
}
