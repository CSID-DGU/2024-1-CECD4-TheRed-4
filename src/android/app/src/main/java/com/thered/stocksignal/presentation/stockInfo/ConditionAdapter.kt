package com.thered.stocksignal.presentation.stockinfo

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.thered.stocksignal.R
import com.thered.stocksignal.Data.model.Condition

class ConditionAdapter(
    private val conditionList: List<Condition>,
    private val onItemClick: (Condition) -> Unit // 클릭 리스너 추가
) : RecyclerView.Adapter<ConditionAdapter.ConditionViewHolder>() {

    inner class ConditionViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(condition: Condition) {
            // condition 데이터를 뷰에 바인딩
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ConditionViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_condition, parent, false)
        return ConditionViewHolder(view)
    }

    override fun onBindViewHolder(holder: ConditionViewHolder, position: Int) {
        val condition = conditionList[position]
        holder.bind(condition)
        holder.itemView.setOnClickListener { onItemClick(condition) } // 클릭 리스너 설정
    }

    override fun getItemCount(): Int = conditionList.size
}
