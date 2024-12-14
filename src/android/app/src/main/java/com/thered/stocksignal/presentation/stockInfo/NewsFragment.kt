package com.thered.stocksignal.presentation.stockinfo

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.text.Html
import android.text.Spannable
import android.text.method.LinkMovementMethod
import android.text.style.URLSpan
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.thered.stocksignal.Data.Network.RetrofitClient
import com.thered.stocksignal.Data.model.NewsResponse
import com.thered.stocksignal.R
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NewsFragment : Fragment() {
    private lateinit var articlePreview: TextView

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_news, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        articlePreview = view.findViewById(R.id.articlePreview)

        val companyName = arguments?.getString("company_name")
        if (!companyName.isNullOrBlank()) {
            fetchNews(companyName)
        } else {
            articlePreview.text = "뉴스가 존재하지 않습니다."
        }
    }

    // 뉴스 API 호출
    private fun fetchNews(companyName: String) {
        articlePreview.text = "뉴스를 가져오는 중입니다..."
        RetrofitClient.newsApi.getNews(companyName).enqueue(object : Callback<NewsResponse> {
            override fun onResponse(call: Call<NewsResponse>, response: Response<NewsResponse>) {
                if (response.isSuccessful) {
                    val newsResponse = response.body()
                    if (newsResponse != null && newsResponse.code == "200" && newsResponse.result == "SUCCESS") {
                        val articles = newsResponse.data
                        if (articles.isNotEmpty()) {
                            // 뉴스 데이터에서 제목과 URL만 HTML 형식으로 변환
                            val formattedText =
                                articles.take(3).joinToString(separator = "<br><br>") { article ->
                                    "<a href=\"${article.url}\">${article.title}</a>"
                                }
                            val spannable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                Html.fromHtml(formattedText, Html.FROM_HTML_MODE_COMPACT)
                            } else {
                                Html.fromHtml(formattedText)
                            } as Spannable
                            articlePreview.text = spannable
                            articlePreview.movementMethod = LinkMovementMethod.getInstance()
                            // URLSpan 클릭 처리
                            handleLinks(spannable)
                        } else {
                            articlePreview.text = "관련 뉴스가 없습니다."
                        }
                    } else {
                        articlePreview.text = "뉴스를 불러오는 데 실패했습니다: ${newsResponse?.message ?: "알 수 없는 오류"}"
                    }
                } else {
                    articlePreview.text = "서버 오류: ${response.code()} - ${response.message()}"
                }
            }
            override fun onFailure(call: Call<NewsResponse>, t: Throwable) {
                articlePreview.text = "네트워크 오류: ${t.localizedMessage}"
            }
        })
    }
    // 링크 클릭 처리
    private fun handleLinks(spannable: Spannable) {
        val spans = spannable.getSpans(0, spannable.length, URLSpan::class.java)
        if (spans.isNotEmpty()) {
            for (span in spans) {
                val url = span.url
                articlePreview.setOnClickListener {
                    openUrl(url)
                }
            }
        }
    }
    // URL 열기
    private fun openUrl(url: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        try {
            startActivity(intent)
        } catch (e: Exception) {
            Log.e("NewsFragment", "Failed to open URL: $url", e)
        }
    }
}