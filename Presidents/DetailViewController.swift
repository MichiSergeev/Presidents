import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView:UIWebView!
    
    private var languageListController: LanguageListControllerTableViewController?
    private var languageButton: UIBarButtonItem?
    
    var languageString = "" {
        didSet {
            if languageString != oldValue {
                configureView()
            }
        }
    }
    
    private func modifyUrlForLanguage(url:String, language lang:String?) -> String {
        var newUrl=url
        if let langStr=lang {
            let range=NSMakeRange(8, 2)
            if !langStr.isEmpty && (url as NSString).substring(with: range) != langStr {
                newUrl=(url as NSString).replacingCharacters(in: range, with: langStr)
            }
        }
        return newUrl
    }


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
//                label.text = detail.description
                let dict = detail as! [String:String]
//                let urlString=dict["url"]!
                let urlString=modifyUrlForLanguage(url: dict["url"]!, language: languageString)
                label.text=urlString
                
                let url=NSURL(string: urlString)!
                let request=URLRequest(url: url as URL)
                webView.loadRequest(request)
                let name=dict["name"]!
                title=name
            }
        }
    }

    @objc func showLanguagePopover() {
        if languageListController==nil {
            languageListController=LanguageListControllerTableViewController()
            languageListController!.detailViewController=self
            languageListController!.modalPresentationStyle = .popover
        }
        present(languageListController!, animated: true, completion: nil)
        if let ppc=languageListController?.popoverPresentationController {
            ppc.barButtonItem=languageButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        languageButton=UIBarButtonItem(title: "Выбери язык", style: .plain, target: self, action: #selector(DetailViewController.showLanguagePopover))
        navigationItem.rightBarButtonItem=languageButton
    }
    
    
    
    
    
    
    var detailItem: AnyObject? {
        didSet {
            configureView()
        }
    }


    
    
    
}

