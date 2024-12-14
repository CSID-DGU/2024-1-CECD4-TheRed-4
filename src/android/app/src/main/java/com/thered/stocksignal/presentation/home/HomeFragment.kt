package com.thered.stocksignal.presentation.home

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.thered.stocksignal.presentation.mystock.MyStockActivity
import com.thered.stocksignal.R
import com.thered.stocksignal.databinding.FragmentHomeBinding
//import com.thered.stocksignal.Presentation.StockInfoActivity

//import com.thered.stocksignal.presentation.stockInfo.StockInfoActivity
import com.thered.stocksignal.presentation.home.placeholder.HomePlaceholderContent

class HomeFragment : Fragment() {

    companion object {
        fun newInstance() = HomeFragment()
    }

    private lateinit var binding: FragmentHomeBinding
    private lateinit var viewModel: HomeViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // TODO: Use the ViewModel
    }

    @SuppressLint("NotifyDataSetChanged", "DetachAndAttachSameFragment")
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        binding = FragmentHomeBinding.inflate(inflater, container, false)
        viewModel = ViewModelProvider(this).get(HomeViewModel::class.java)
        Log.d("Network_db", "go")
        binding.viewModel = viewModel
        binding.lifecycleOwner = viewLifecycleOwner

        viewModel.stockList.observe(viewLifecycleOwner) { items ->
            HomePlaceholderContent.ITEMS.clear()
            HomePlaceholderContent.setItem(items.stocks)
            viewModel.setTime(items.timeLine)
            Log.d("Network_", items.toString())

            childFragmentManager.beginTransaction()
                .replace(R.id.stock_list, StockCoverFragment())
                .commit()
        }

        viewModel.startActivityEvent.observe(viewLifecycleOwner) {
            val intent = Intent(requireContext(), MyStockActivity::class.java)
            startActivity(intent)
        }

        viewModel.fetchStockList()

        viewModel.test.observe(viewLifecycleOwner) { item ->
            Log.d("test", item.toString())
        }
        viewModel.getTest()

        return binding.root
    }
}