///
abstract interface class NextPageFetcher {
  Future<(bool, String)> fetchNextPage();
}
