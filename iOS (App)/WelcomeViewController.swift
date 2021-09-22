//
//  WelcomeViewController.swift
//  Turn Off the Lights for Safari (iOS)
//
//  Created by Stefan Van Damme on 13/06/2021.
//

import Foundation
import UIKit
import SafariServices
import LinkPresentation

class AnimatedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
            animate(transform)
        }
    }

}

private extension AnimatedButton {
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut],
            animations: {
                self.transform = transform
            }
        )
    }
}

class WelcomeViewController: UIViewController, UIActivityItemSource {
    var metadata: LPLinkMetadata?

    @IBOutlet weak var imagepeople: UIImageView!
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return self.metadata
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return String.localizedStringWithFormat(NSLocalizedString("lblplaceholder", comment: ""), "")
    }

    let websitelink = "https://www.turnoffthelights.com"
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToTwitter {
            return String.localizedStringWithFormat(NSLocalizedString("lblsharetwitter", comment: ""), "") + " " + websitelink
        } else {
            return String.localizedStringWithFormat(NSLocalizedString("lblshareregular", comment: ""), "") + " " + websitelink
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("lblemailsubject", comment: ""), "")
    }
    
    @IBAction func openoptions(_ sender: Any) {
        if let url = URL(string: "https://www.turnoffthelights.com/extension/redirection/") {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if traitCollection.horizontalSizeClass == .compact {
            // iPhone size
            self.navigationItem.title = "Turn Off the Lights"
        } else {
            // large iPad size
            self.navigationItem.title = ""
        }
        hidepeoplesmallscreen()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            // iPhone size
            self.navigationItem.title = "Turn Off the Lights"
        } else {
            // large iPad size
            self.navigationItem.title = ""
        }
    }
        
    @IBOutlet weak var btnshare: UIButton!
    @IBAction func bigshareaction(_ sender: Any) {
            let url = URL(string: "https://www.turnoffthelights.com")!
            LPMetadataProvider().startFetchingMetadata(for: url) { [self] linkMetadata, _ in
                //linkMetadata?.iconProvider = linkMetadata?.imageProvider
                self.metadata = linkMetadata
                let items = [self]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                // Check if user is on iPad and present popover
                if UIDevice.current.userInterfaceIdiom == .pad {
                    DispatchQueue.main.async {
                        if let popoverPresentationController = ac.popoverPresentationController {
                            popoverPresentationController.sourceView = self.btnshare
                            popoverPresentationController.sourceRect = self.btnshare.bounds;
                            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection.down;
                        }
                    }
                }
                
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                // Present share activityView on regular iPhone
                DispatchQueue.main.async {
                    self.present(ac, animated: true)
                }
            }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation{
        case .landscapeLeft, .landscapeRight:
            let screenSize: CGFloat = UIScreen.main.bounds.height
            if(screenSize <= 320.0){
                imagepeople.isHidden = true
            }
            break;
        default:
            imagepeople.isHidden = false
        }
    }
    
    func hidepeoplesmallscreen(){
        if UIDevice.current.orientation.isLandscape {
            //print("Landscape")
            imagepeople.isHidden = false
        } else {
            //print("Portrait")
            let screenSize: CGFloat = UIScreen.main.bounds.height
            if(screenSize <= 320.0){
               imagepeople.isHidden = true
            }
        }
    }
}
