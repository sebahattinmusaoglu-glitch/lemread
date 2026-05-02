import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lemread/models/category.dart';
import 'package:lemread/models/article.dart';
import 'package:lemread/models/question.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Category>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name', ascending: true);
    return (response as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  Future<List<Article>> getArticlesByCategory(int categoryId) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('category_id', categoryId)
        .order('id');
    return (response as List)
        .map((json) => Article.fromJson(json))
        .toList();
  }

  Future<List<Question>> getQuestionsByArticle(int articleId) async {
    final response = await _client
        .from('questions')
        .select()
        .eq('article_id', articleId)
        .order('id');
    return (response as List)
        .map((json) => Question.fromJson(json))
        .toList();
  }
}