package com.thered.stocksignal.presentation.home

import android.graphics.Color
import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.RequestOptions

import com.thered.stocksignal.presentation.home.placeholder.HomePlaceholderContent.PlaceholderItem
import com.thered.stocksignal.databinding.FragmentStockCoverBinding

/**
 * [RecyclerView.Adapter] that can display a [PlaceholderItem].
 * TODO: Replace the implementation with code for your data type.
 */
class MyStockCoverRecyclerViewAdapter(
    private val values: List<PlaceholderItem>,
    private val onItemClick: (PlaceholderItem) -> Unit  // 클릭 리스너 추가
) : RecyclerView.Adapter<MyStockCoverRecyclerViewAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {

        return ViewHolder(
            FragmentStockCoverBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )
        )

    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = values[position]
        holder.idView.text = item.id
        holder.contentView.text = item.content
        holder.priceView.text = item.price.toString()
        holder.earnRateView.text = item.earnRate

        if (item.earnRate[0] == '-')
            holder.earnRateView.setTextColor(Color.parseColor("#0080FF"))
        else if (item.earnRate == "+0.0%")
            holder.earnRateView.setTextColor(Color.parseColor("#333333"))

        Glide.with(holder.imageView.context)
            .load(item.imgUrl)
            .apply(RequestOptions().transform(RoundedCorners(80)))
            .into(holder.imageView)
    }

    override fun getItemCount(): Int = values.size

    inner class ViewHolder(binding: FragmentStockCoverBinding) :
        RecyclerView.ViewHolder(binding.root) {
        val idView: TextView = binding.itemNumber
        val contentView: TextView = binding.content
        val priceView: TextView = binding.price
        val earnRateView: TextView = binding.earnRate
        val imageView: ImageView = binding.imageView

        override fun toString(): String {
            return super.toString() + " '" + contentView.text + "'"
        }

        // 초기화 블록에서 클릭 이벤트 처리
        init {
            binding.root.setOnClickListener {
                val position = adapterPosition
                if (position != RecyclerView.NO_POSITION) {
                    onItemClick(values[position])  // 클릭된 아이템 전달
                }
            }
        }
    }

}