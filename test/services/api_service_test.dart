import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_flash/data/enum/news_category.dart';
import 'package:news_flash/models/news_response_model.dart';
import 'package:news_flash/data/services/api_service.dart';

@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiService apiService;
  
  // Dados de teste
  final successResponse = {
    'status': 'ok',
    'totalResults': 10,
    'articles': [
      {
        'source': {'id': 'test-source', 'name': 'Test Source'},
        'author': 'Test Author',
        'title': 'Test Title',
        'description': 'Test Description',
        'url': 'https://test.com',
        'urlToImage': 'https://test.com/image.jpg',
        'publishedAt': '2023-01-01T12:00:00Z',
        'content': 'Test Content'
      }
    ]
  };
  
  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(httpClient: mockClient);
  });
  
  group('ApiService', () {
    test('should return news list when API call is successful', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      final result = await apiService.getNewsByCategory(NewsCategory.general);
      
      // Assert
      expect(result, isA<List<NewsResponse>>());
      expect(result.length, 1);
      expect(result[0].status, 'ok');
      expect(result[0].totalResults, 10);
      expect(result[0].articles.length, 1);
      expect(result[0].articles[0].title, 'Test Title');
      expect(result[0].articles[0].author, 'Test Author');
      expect(result[0].articles[0].source.name, 'Test Source');
    });
    
    test('should throw exception when API call fails with status code other than 200', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Erro ao carregar as notícias: 404')
        )),
      );
    });
    
    test('should throw exception when socket exception occurs', () async {
      // Arrange
      when(mockClient.get(any)).thenThrow(const SocketException('No internet'));
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Sem conexão com a Internet')
        )),
      );
    });
    
    test('should throw exception when http exception occurs', () async {
      // Arrange
      when(mockClient.get(any)).thenThrow(const HttpException('Not found'));
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Não foi possível encontrar as notícias')
        )),
      );
    });
    
    test('should throw exception when format exception occurs', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Invalid JSON', 200));
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Formato de resposta inválido')
        )),
      );
    });
    
    test('should throw exception for unexpected errors', () async {
      // Arrange
      when(mockClient.get(any)).thenThrow(Exception('Unexpected error'));
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Erro inesperado')
        )),
      );
    });
    
    test('should build correct URL for general category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getNews();
      
      // Assert - Verificar se a URL contém os parâmetros corretos
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines') && 
        uri.toString().contains('q=keyword')
      ))));
    });
    
    test('should build correct URL for business category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getBusinessNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=business')
      ))));
    });
    
    test('should build correct URL for entertainment category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getEntertainmentNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=entertainment')
      ))));
    });
    
    test('should build correct URL for health category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getHealthNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=health')
      ))));
    });
    
    test('should build correct URL for science category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getScienceNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=science')
      ))));
    });
    
    test('should build correct URL for technology category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getTechnologyNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=technology')
      ))));
    });
    
    test('should build correct URL for sports category', () async {
      // Arrange
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(json.encode(successResponse), 200));
      
      // Act
      await apiService.getSportsNews();
      
      // Assert
      verify(mockClient.get(argThat(predicate<Uri>((uri) => 
        uri.toString().contains('top-headlines/sources') && 
        uri.toString().contains('category=sports')
      ))));
    });
    
    test('should call dispose on http client when service is disposed', () {
      // Act
      apiService.dispose();
      
      // Assert
      verify(mockClient.close()).called(1);
    });
    
    test('should handle request timeout', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 11), 
          () => http.Response('', 200)
        )
      );
      
      // Act & Assert
      expect(
        () => apiService.getNewsByCategory(NewsCategory.general),
        throwsA(isA<Exception>()),
      );
    });
    
    test('should use capitalize extension correctly', () {
      // Act & Assert
      expect('test'.capitalize(), equals('Test'));
      expect(''.capitalize(), equals(''));
    });
  });
}
