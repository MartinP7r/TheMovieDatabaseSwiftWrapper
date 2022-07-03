@testable import TMDBSwift
import XCTest

final class MovieServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        TMDBConfig.apikey = "0"
    }

    func testInit() {
        let movieService = MovieService()

        let actualURLSession = movieService.urlSession

        XCTAssertNotNil(actualURLSession as? URLSession)
    }

    // MARK: - Get Details

    func testDetails() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(Movie.mock))

        let data = try? await MovieService(urlSession: urlSession).details(for: 11)
        XCTAssertNotNil(data)
    }

    func testDetails_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).details(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testFetchDetails_Success() throws {
        var data: Movie?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(Movie.mock))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchDetails(for: 11) { movie in
            data = movie
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testFetchDetails_Failure() {
        var data: Movie? = Movie.mock
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchDetails(for: 11) { movie in
            data = movie
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }

    // MARK: - Get Alternative Titles

    func testAlternativeTitles() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(AlternativeTitlesResponse.mock))

        let data = try await MovieService(urlSession: urlSession).alternativeTitles(for: 11, country: "anything")
        XCTAssertNotNil(data)
    }

    func testAlternativeTitles_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).alternativeTitles(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testFetchAlternativeTitles_Success() throws {
        var data: [Title]?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(AlternativeTitlesResponse.mock))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchAlternativeTitles(for: 11) { titles in
            data = titles
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testFetchAlternativeTitles_Failure() {
        var data: [Title]? = [Title.mock]
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchAlternativeTitles(for: 11) { titles in
            data = titles
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }

    // MARK: - Get Credits

    func testCredits() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(Credits.mock))

        let data = try await MovieService(urlSession: urlSession).credits(for: 11)
        XCTAssertNotNil(data)
    }

    func testCredits_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).credits(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testFetchCredits_Success() throws {
        var data: Credits?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(Credits.mock))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchCredits(for: 11) { credits in
            data = credits
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testFetchCredits_Failure() {
        var data: Credits? = Credits.mock
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchCredits(for: 11) { credits in
            data = credits
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }

    // MARK: - Get External IDs

    func testExternalIDs() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(ExternalIDResponse.mock))

        let data = try await MovieService(urlSession: urlSession).externalIDs(for: 11)
        XCTAssertFalse(data.isEmpty)
    }

    func testExternalIDs_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).externalIDs(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testFetchExternalIDs_Success() throws {
        var data: [ExternalIDType]?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(ExternalIDResponse(id: 1, imdb: nil, facebook: nil, instagram: nil, twitter: "12345")))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchExternalIDs(for: 11) { types in
            data = types
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testFetchExternalIDs_Failure() {
        var data: [ExternalIDType]? = [.imdb("123")]
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchExternalIDs(for: 11) { types in
            data = types
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }

    // MARK: - Get Images

    func testImages() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(ImageResponse.mock))

        let data = try await MovieService(urlSession: urlSession).images(for: 11, languages: ["en", "null"])
        XCTAssertNotNil(data.0)
        XCTAssertNotNil(data.1)
        XCTAssertNotNil(data.2)
    }

    func testImages_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).images(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testImages_Success() throws {
        var data: ([Image]?, [Image]?, [Image]?)
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(ImageResponse.mock))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchImages(for: 11) { backdrops, logos, posters in
            data = (backdrops, logos, posters)
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data.0)
        XCTAssertNotNil(data.1)
        XCTAssertNotNil(data.2)
    }

    func testImages_Failure() {
        var data: ([Image]?, [Image]?, [Image]?) = ([Image.mock], [Image.mock], [Image.mock])
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchImages(for: 11) { backdrops, logos, posters in
            data = (backdrops, logos, posters)
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data.0)
        XCTAssertNil(data.1)
        XCTAssertNil(data.2)
    }

    // MARK: - Get Keywords

    func testKeywords() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(KeywordResponse(id: 1, keywords: [Keyword(name: name, id: 1)])))

        let data = try await MovieService(urlSession: urlSession).keywords(for: 11)
        XCTAssertFalse(data.isEmpty)
    }

    func testKeywords_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).keywords(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testFetchKeywords_Success() throws {
        var data: [Keyword]?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(KeywordResponse(id: 1, keywords: [Keyword(name: name, id: 1)])))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchKeywords(for: 11) { keywords in
            data = keywords
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testFetchKeywords_Failure() {
        var data: [Keyword]? = [Keyword(name: "name", id: 0)]
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchKeywords(for: 11) { keywords in
            data = keywords
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }

    // MARK: - Get Lists

    func testLists() async throws {
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(PagedResults<[List]>(page: 1, pageCount: 10, resultCount: 100, results: [List.mock])))

        let data = try await MovieService(urlSession: urlSession).lists(for: 11, page: 1)
        XCTAssertNotNil(data as PagedResults<[List]>)
    }

    func testLists_InvalidAPIKey() async throws {
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        TMDBConfig.apikey = nil

        do {
            _ = try await MovieService(urlSession: urlSession).keywords(for: 11)
            XCTFail("Function should have thrown by now")
        } catch let error as TMDBError {
            XCTAssertEqual(error, TMDBError.invalidAPIKey)
        }
    }

    func testLists_Success() throws {
        var data: PagedResults<[List]>?
        let urlSession = MockURLSession()
        urlSession.result = try .success(JSONEncoder().encode(PagedResults<[List]>(page: 1, pageCount: 10, resultCount: 100, results: [List.mock])))

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchLists(for: 11) { results in
            data = results
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNotNil(data)
    }

    func testLists_Failure() {
        var data: PagedResults<[List]>? = PagedResults<[List]>(page: 1, pageCount: 10, resultCount: 100, results: [List.mock])
        let urlSession = MockURLSession()
        urlSession.result = .failure(NSError())

        let expectation = self.expectation(description: "Wait for data to load.")

        MovieService(urlSession: urlSession).fetchLists(for: 11) { results in
            data = results
            expectation.fulfill()
        }
        waitForExpectations(timeout: expecationTimeout, handler: nil)
        XCTAssertNil(data)
    }
}