import UIKit

enum BSKeyboardControl: UInt8 {
    case AllZeros = 0b00
    case PreviousNext = 0b01
    case Done = 0b10
    case AllButtons = 0b11		// Needed for pretty weak Swift NSOption support
}

enum BSKeyboardControlsDirection: Int {
    case Previous = 0
    case Next = 1
}

protocol BSKeyboardControlsDelegate {
    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection);
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls)
}

class BSKeyboardControls: UIView {
    var toolbar: UIToolbar!
    var doneButton: UIBarButtonItem!
    var previousButton: UIBarButtonItem!
    var nextButton: UIBarButtonItem!
    
    var delegate: BSKeyboardControlsDelegate?
    var visibleControls: BSKeyboardControl = .AllZeros {
        didSet {
            updateToolbar()
        }
    }
    var fields: [UIView] = [] {
        didSet {
            installOnFields()
        }
    }
    
    var activeField: UIView? {
        didSet {
            activeField?.becomeFirstResponder()
            updatePreviousNextEnabledStates()
        }
    }
    
    var barStyle: UIBarStyle {
        get {return toolbar.barStyle}
        set {toolbar.barStyle = newValue}
    }
    var barTintColor: UIColor? {
        get {return toolbar.barTintColor}
        set {toolbar.barTintColor = newValue}
    }
    var doneTintColor: UIColor? {
        get {return doneButton.tintColor}
        set {doneButton.tintColor = newValue}
    }
    var doneTitle: String? {
        get {return doneButton.title}
        set {doneButton.title = newValue}
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(fields: [])
    }
    
    override convenience init(frame: CGRect) {
        self.init(fields: [])
    }
    
    init(fields: [UIView]) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolbar = UIToolbar(frame: self.frame)
        barStyle = .default
        toolbar.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin]
        addSubview(toolbar)
        
        previousButton=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem(rawValue: 105)!, target: self, action: #selector(BSKeyboardControls.selectPreviousField))
        nextButton=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem(rawValue: 106)!, target: self, action: #selector(BSKeyboardControls.selectNextField))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(BSKeyboardControls.doneButtonPressed))
        visibleControls = BSKeyboardControl(rawValue: BSKeyboardControl.PreviousNext.rawValue | BSKeyboardControl.Done.rawValue)!
        self.fields = fields
        // didSet observers not called from init()
        installOnFields()
        updateToolbar()
    }
    
    func installOnFields() {
        for field in fields {
            if let field = field as? UITextView {
                field.inputAccessoryView = self
            } else if let field = field as? UITextField {
                field.inputAccessoryView = self
            } else {
                print("Field is not TextView or TextField: \(field)")
            }
        }
    }
    
    func updateToolbar() {
        toolbar.items = toolbarItems() as? [UIBarButtonItem]
    }
    
    func toolbarItems() -> [AnyObject] {
        var outItems = [AnyObject]()
        
        if visibleControls.rawValue & BSKeyboardControl.PreviousNext.rawValue > 0 {
            outItems.append(previousButton)
            let fixedSpace=UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedSpace.width=22.0
            outItems.append(fixedSpace)
            outItems.append(nextButton)
        }
        if visibleControls.rawValue & BSKeyboardControl.Done.rawValue > 0 {
            outItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            outItems.append(doneButton)
        }
        return outItems
    }
    
    func updatePreviousNextEnabledStates() {
        if let index = fields.index(of: activeField!) {
            previousButton.isEnabled = (index > 0)
            nextButton.isEnabled = (index < fields.count - 1)
        }
    }
    
    @objc func selectPreviousField() {
        if let index = fields.index(of: activeField!) {
            if index > 0 {
                activeField = fields[index - 1]
                delegate?.keyboardControls(keyboardControls: self, selectedField: activeField!, inDirection: .Previous)
            }
        }
    }
    
    @objc func selectNextField() {
        if let index = fields.index(of: activeField!) {
            if index < fields.count - 1 {
                activeField = fields[index + 1]
                delegate?.keyboardControls(keyboardControls: self, selectedField: activeField!, inDirection: .Next)
            }
        }
    }
    
    @objc func doneButtonPressed() {
        delegate?.keyboardControlsDonePressed(keyboardControls: self)
    }
}
