package com.thered.stocksignal.presentation.home

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.thered.stocksignal.R
import com.thered.stocksignal.presentation.home.placeholder.HomePlaceholderContent
import com.thered.stocksignal.presentation.stockinfo.StockInfoActivity

/**
 * A fragment representing a list of Items.
 */
class StockCoverFragment : Fragment() {

    private var columnCount = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        arguments?.let {
            columnCount = it.getInt(ARG_COLUMN_COUNT)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_stock_cover_list, container, false)

        val recyclerView: RecyclerView = view.findViewById(R.id.list)

        // Set the adapter
        if (recyclerView is RecyclerView) {
            with(recyclerView) {
                layoutManager = when {
                    columnCount <= 1 -> LinearLayoutManager(context)
                    else -> GridLayoutManager(context, columnCount)
                }

//                 어댑터 설정 시 클릭 리스너 추가 (StockInfoActivity로 이동하지 않음)
                adapter = MyStockCoverRecyclerViewAdapter(HomePlaceholderContent.ITEMS) { clickedItem ->
                    Log.d("StockCoverFragment", "Clicked Item: ${clickedItem.content}")
                    // 여기서는 클릭된 항목에 대해 다른 작업을 처리하거나, 추가 로직을 구현할 수 있음
                    // 예: 로그 출력, 다른 화면 이동 등
                    val intent = Intent(requireContext(), StockInfoActivity::class.java).apply {
                        putExtra("company_name", clickedItem.content)// 회사 이름 등 데이터 추가
                        putExtra("stock_price", clickedItem.price)
                        putExtra("earn_rate", clickedItem.earnRate)
                        putExtra("image_url", clickedItem.imgUrl)
                    }
                    startActivity(intent)
                }
            }
        }
        return view
    }

    companion object {
        const val ARG_COLUMN_COUNT = "column-count"

        @JvmStatic
        fun newInstance(columnCount: Int) =
            StockCoverFragment().apply {
                arguments = Bundle().apply {
                    putInt(ARG_COLUMN_COUNT, columnCount)
                }
            }
    }
}
