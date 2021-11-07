# frozen_string_literal: true

RSpec.describe '/api/authors' do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }
  let(:user) { create(:user) }

  describe 'GET to /' do
    it 'returns all authors' do
      author = create(:author)

      get api_authors_path

      expect(response_hash).to eq(
        [
          {
            created_at: author.created_at.iso8601(3),
            description: author.description,
            first_name: author.first_name,
            last_name: author.last_name,
            genres: author.genres,
            id: author.id,
            updated_at: author.updated_at.iso8601(3),
            website: author.website
          }
        ]
      )
    end
  end

  describe 'GET to /:id' do
    context 'when found' do
      it 'returns an author' do
        author = create(:author)

        get api_author_path(author)

        expect(response_hash).to eq(
          {
            created_at: author.created_at.iso8601(3),
            description: author.description,
            first_name: author.first_name,
            last_name: author.last_name,
            genres: author.genres,
            id: author.id,
            updated_at: author.updated_at.iso8601(3),
            website: author.website
          }
        )
      end
    end

    context 'when not found' do
      it 'returns not_found' do
        get api_author_path(-1)

        expect(response).to be_not_found
      end
    end
  end

  describe 'POST to /' do
    before do
      login_with_api(user)
      @headers = {'Authorization': response.headers['Authorization']}
    end
    context 'when successful' do
      let(:params) do
        {
          description: 'Hop on pop',
          first_name: 'Dr.',
          last_name: 'Seuss',
          genres: ['Children\'s Books'],
          website: 'https://www.seussville.com'
        }
      end

      it 'creates an author' do
        expect { post '/api/authors', params: params, headers: @headers }.to change(Author, :count)
      end

      it 'returns the created author' do
        post '/api/authors', params: params, headers: @headers

        expect(response_hash).to include(params)
      end
    end

    context 'when unsuccessful' do
      let(:params) {}

      it 'returns an error' do
        post '/api/authors', params: params, headers: @headers

        expect(response_hash).to eq(
          {
            errors: ['Description can\'t be blank']
          }
        )
      end
    end

    context 'When the Authorization header is missing' do
      it 'returns 401' do
        post '/api/authors'
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PUT to /:id' do
    let(:author) { create(:author) }

    context 'when successful' do
      before do
        login_with_api(user)
        @headers = {'Authorization': response.headers['Authorization']}
      end
      let(:params) do
        {
          description: 'I do not like green eggs and ham'
        }
      end

      it 'updates an existing author' do
        put "/api/authors/#{author.id}", params: params, headers: @headers

        expect(author.reload.description).to eq(params[:description])
      end

      it 'returns the updated author' do
        put "/api/authors/#{author.id}", params: params, headers: @headers
        expect(response_hash).to include(params)
      end
    end

    context 'when unsuccessful' do
      before do
        login_with_api(user)
        @headers = {'Authorization': response.headers['Authorization']}
      end
      let(:params) do
        {
          description: ''
        }
      end

      it 'returns an error' do
        put "/api/authors/#{author.id}", params: params, headers: @headers

        expect(response_hash).to eq(
          {
            errors: ['Description can\'t be blank']
          }
        )
      end
    end

    context 'When the Authorization header is missing' do
      it 'returns 401' do
        put "/api/authors/#{author.id}"
        expect(response.status).to eq(401)
      end
    end
  end
end
