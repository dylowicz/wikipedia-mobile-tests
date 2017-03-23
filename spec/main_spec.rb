require 'spec_helper'

describe "Wikipedia Test" do
  let(:search_query) { 'furry rabbits' }
  let(:suggestion) { 'Did you mean "fury rabbit"?' }
  let(:suggested_article_name) { 'Brutal: Paws of Fury' }

  before(:all) do
    wait_true { on(Android::SearchBar).search_bar_element.visible? }
  end

  # action
  it "searches for article" do
    on(Android::SearchBar).search_for search_query
  end

  # verify
  it "finds suggestion" do
    expect(on(Android::SearchBar).search_suggestion_element.when_present.text).to eq(suggestion)
  end

  # action
  it "goes to suggestion" do
    on(Android::SearchBar).go_to_suggestion
  end

  # verify
  it "finds list of results" do
    expect(on(Android::SearchResultsListPage).search_results_list_element.when_present).to be_visible
    expect(on(Android::SearchResultsListPage).search_results_items_elements.size).to be > 0
  end

  # verify
  it "checks suggested article is first on the list" do
    expect(on(Android::SearchResultsListPage).search_results_items_elements.first.text).to eq(suggested_article_name)
  end

  # action
  it "opens the first result" do
    on(Android::SearchResultsListPage).go_to_first_result
  end

  # verify
  it "checks that article has a proper title" do
    expect(on(Android::ArticlePage).article_title_element.when_present.text).to eq(suggested_article_name)
  end

  # action
  it "adds article to reading list" do
    on(Android::ArticleNavigationBar).add_to_reading_list
  end

  # action
  it "acknowledges reading list onboarding" do
    on(Android::ReadingListOnboardingWidget).acknowledge
  end

  # action
  it "creates a new reading list in a widget" do
    on(Android::ReadingListCreateWidget).create_list
  end

  # action
  it "closes article and goes to home page" do
    on(Android::ArticleActionBar).close_article
  end

  # action
  it "goes to reading list page" do
    on(Android::HomeNavigationBar).go_to_reading_lists
  end

  # action
  it "opens first reading list" do
    on(Android::ReadingListsPage).open_first_list
  end

  # verify
  it "checks that previously added article is on the list" do
    expect(on(Android::ReadingListPage).find_article_by_title(suggested_article_name).when_present.text).to eq(suggested_article_name)
  end

  # action
  it "removes article from reading list" do
    on(Android::ReadingListPage).delete_article(suggested_article_name)
  end

  # verify
  it "checks popup saying that article was removed" do
    expect(on(Android::ReadingListPage).deleted_article_popup_element.text).to eq("#{suggested_article_name} removed from list")
  end

  # verify
  it "checks that no article is present on the reading list" do
    expect(on(Android::ReadingListPage).find_article_by_title(suggested_article_name)).to be_nil
  end
end
