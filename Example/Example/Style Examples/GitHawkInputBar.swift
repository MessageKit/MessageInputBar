/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageInputBar

class GitHawkInputBar: MessageInputBar {
    
    private let githawkImages: [UIImage] = [#imageLiteral(resourceName: "ic_eye"), #imageLiteral(resourceName: "ic_bold"), #imageLiteral(resourceName: "ic_italic"), #imageLiteral(resourceName: "ic_at"), #imageLiteral(resourceName: "ic_list"), #imageLiteral(resourceName: "ic_code"), #imageLiteral(resourceName: "ic_link"), #imageLiteral(resourceName: "ic_hashtag"), #imageLiteral(resourceName: "ic_upload")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundView.backgroundColor = .white
        inputTextView.backgroundColor = .clear
        inputTextView.layer.borderWidth = 0
        inputTextView.placeholder = "Leave a comment"
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_send").withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = tintColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 20, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        let collectionView = AttachmentCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.intrinsicContentHeight = 20
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        bottomStackView.addArrangedSubview(collectionView)
        collectionView.reloadData()
    }
    
}

extension GitHawkInputBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return githawkImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        cell.imageView.image = githawkImages[indexPath.section].withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = .black
        return cell
    }
    
}
