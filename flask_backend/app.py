from flask import Flask, jsonify, request, url_for
import ssl

app = Flask(__name__)

@app.route('/books', methods=['GET'])
def get_books():
    server_url = request.base_url
    books = [
        {
            'name': 'Book 1',
            'author': 'Author 1',
            'description': 'Description 1',
            'language': 'English',
            'cover_image_path': server_url + url_for('static', filename='assets/images/book1.jpg'),
            'pdf_path': server_url + url_for('static', filename='assets/pdfs/book1.pdf'),
            'genre' : 'Fiction'
        },
        {
            'name': 'Book 2',
            'author': 'Author 2',
            'description': 'Description 2',
            'language': 'Hindi',
            'cover_image_path': server_url + url_for('static', filename='assets/images/book2.jpg'),
            'pdf_path': server_url + url_for('static', filename='assets/pdfs/book2.pdf'),
            'genre' : 'Non Fiction'
        },
        {
            'name': 'Book 3',
            'author': 'Author 3',
            'description': 'Description 3',
            'language': 'Telugu',
            'cover_image_path': server_url + url_for('static', filename='assets/images/book3.jpg'),
            'pdf_path': server_url + url_for('static', filename='assets/pdfs/book3.pdf'),
            'genre' : 'Fiction'
        },
        {
            'name': 'Book 4',
            'author': 'Author 4',
            'description': 'Description 4',
            'language': 'Tamil',
            'cover_image_path': server_url + url_for('static', filename='assets/images/book4.jpg'),
            'pdf_path': server_url + url_for('static', filename='assets/pdfs/book4.pdf'),
            'genre' : 'Non Fiction'
        },
        {
            'name': 'Book 5',
            'author': 'Author 5',
            'description': 'Description 5',
            'language': 'English',
            'cover_image_path': server_url + url_for('static', filename='assets/images/book5.jpg'),
            'pdf_path': server_url + url_for('static', filename='assets/pdfs/book5.pdf'),
            'genre' : 'Fiction'
        }
    ]
    return jsonify(books)

if __name__ == '__main__':
    context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
    context.load_cert_chain('cert.pem', 'key.pem')
    app.run(host="0.0.0.0", port=51000, debug=True, ssl_context=context)
