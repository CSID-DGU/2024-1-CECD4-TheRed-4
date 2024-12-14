package com.thered.stocksignal.presentation.mystock

import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.runtime.snapshots.Snapshot.Companion.observe
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProvider
import com.thered.stocksignal.R
import com.thered.stocksignal.databinding.ActivityMyStockBinding
import com.thered.stocksignal.presentation.home.HomeViewModel
import com.thered.stocksignal.presentation.home.StockCoverFragment
import com.thered.stocksignal.presentation.home.placeholder.HomePlaceholderContent
import com.thered.stocksignal.presentation.mystock.placeholder.MyStockPlaceholderContent

class MyStockActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMyStockBinding
    private lateinit var viewModel: HomeViewModel
    private val stockList: FrameLayout by lazy { findViewById(R.id.my_stock_list)}

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_my_stock)
        viewModel = ViewModelProvider(this).get(HomeViewModel::class.java)
        binding.viewModel = viewModel
        binding.lifecycleOwner = this

        viewModel.myBalance.observe(this) { items ->
            MyStockPlaceholderContent.ITEMS.clear()
            MyStockPlaceholderContent.setItem(items.stocks)
            viewModel.setBalance(items.timeLine, items.totalStockPrice, items.totalStockPL)
            Log.d("Network_", items.toString())
            supportFragmentManager.beginTransaction()
                .replace(stockList.id, MystockCoverFragment())
                .commit()

        }
        viewModel.fetchMyBalance()
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

}