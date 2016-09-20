//
//  ViewController.swift
//  SalaryCalculator
//
//  Created by Kunal Siddhapura on 27/07/2016.
//  Copyright © 2016 Kunal Siddhapura. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Charts

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.doCalculations), name: settingsSyncNotificationKey, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.changeLabelsOnSegment), name: changeOfWeeklyOptionKey, object: nil)
    
    doCalculations()
  }
  
  let currencyFormatDisplay = NSNumberFormatter()
  let currencyFormatInput = NSNumberFormatter()
  let instanceOfUserPrefs = UserPrefs()
  let instanceOfAnnualSalary = AnnualSalary()
  let instanceOfSCB = SalaryCalculatorBrains()
  let instanceOfOutput = DisplayOutput()

  //Outlets On Main Page
  @IBOutlet weak var netIncomeDisplay: UILabel!
  @IBOutlet weak var totalTaxPaidDisplay: UILabel!
	@IBOutlet weak var totalTaxableIncome: UILabel!
	@IBOutlet weak var annualSalaryOutput: UILabel!
	@IBOutlet weak var freqSal: UISegmentedControl!
	@IBOutlet weak var entrySalary: UITextField!
	@IBOutlet weak var freqTakehome: UISegmentedControl!
	@IBOutlet weak var pensionPaidDisplay: UILabel!
  @IBOutlet weak var niContributionsDisplay: UILabel!
  @IBOutlet weak var studentLoanDisplay: UILabel!
  

  @IBOutlet var pieChartDisplay: PieChartView!
  
  func doCalculations() {
    currencyFormatDisplay.currencySymbol = "£"
    currencyFormatDisplay.numberStyle = .CurrencyStyle
    let salaryEntered:Float
    if (entrySalary.text == ""){
      salaryEntered = 0
    }
    else{
      salaryEntered = Float(currencyFormatDisplay.numberFromString(entrySalary.text!)!)
    }
    //let salaryEntered = Float(currencyFormatDisplay.numberFromString(entrySalary.text!)!)
    
    let annualSalary:Float = instanceOfAnnualSalary.calculateAnnualSalary(salaryEntered, frequencyChosen: freqSal.selectedSegmentIndex)
    let annualTaxableIncome = instanceOfSCB.calculateTotalTaxableIncome(annualSalary)
    let annualPensionPaid = instanceOfSCB.calculateAnnualPension(annualSalary)
    let annualNIContributions = instanceOfSCB.calculateNIContributions(annualSalary)
    let annualTaxPaid = instanceOfSCB.calculateAnnualTaxPayment(annualTaxableIncome)
    let annualStudentLoan = instanceOfSCB.calculateStudentLoan(annualSalary, optionChosen: UserPrefs.studentLoanOption)
    let annualNetIncome = annualSalary - (annualNIContributions + annualTaxPaid + annualPensionPaid + annualStudentLoan)
    
    let displayTotalIncome = instanceOfOutput.displayOutput(annualSalary, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayTaxableIncome = instanceOfOutput.displayOutput(annualTaxableIncome, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayAnnualTaxPaid = instanceOfOutput.displayOutput(annualTaxPaid, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayNIContributions = instanceOfOutput.displayOutput(annualNIContributions, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayStudentLoan = instanceOfOutput.displayOutput(annualStudentLoan, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayPensionPaid = instanceOfOutput.displayOutput(annualPensionPaid, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    let displayNetIncome = instanceOfOutput.displayOutput(annualNetIncome, frequencyOfOutput: freqTakehome.selectedSegmentIndex)
    
    //Displays Output
    annualSalaryOutput.text = currencyFormatDisplay.stringFromNumber(displayTotalIncome)
    totalTaxableIncome.text = currencyFormatDisplay.stringFromNumber(displayTaxableIncome)
    totalTaxPaidDisplay.text = currencyFormatDisplay.stringFromNumber(displayAnnualTaxPaid)
    niContributionsDisplay.text = currencyFormatDisplay.stringFromNumber(displayNIContributions)
    studentLoanDisplay.text = currencyFormatDisplay.stringFromNumber(displayStudentLoan)
    pensionPaidDisplay.text = currencyFormatDisplay.stringFromNumber(displayPensionPaid)
    netIncomeDisplay.text = currencyFormatDisplay.stringFromNumber(displayNetIncome)
    
    //let months = ["Tax Paid", "National Insurance", "Student Loan", "Net Income"]
    var displayDataTypes = [String]()
    var displayDataValues = [Double]()
    
    //need to aarange order for consistent PI Chart Colors!!!!
    
    if annualTaxPaid > 0 {
      displayDataTypes.append("Tax Paid")
      displayDataValues.append(Double(annualTaxPaid))
    }
    if annualNIContributions > 0 {
      displayDataTypes.append("National Insurance")
      displayDataValues.append(Double(annualNIContributions))
    }
    if annualStudentLoan > 0 {
      displayDataTypes.append("Student Loan")
      displayDataValues.append(Double(annualStudentLoan))
    }
    if annualPensionPaid > 0 {
      displayDataTypes.append("Pension")
      displayDataValues.append(Double(annualPensionPaid))
    }
    if annualNetIncome > 0 {
      displayDataTypes.append("Net Income")
      displayDataValues.append(Double(annualNetIncome))
    }
    setChart(displayDataTypes, values: displayDataValues, centre: annualSalary)
  }
  
  func changeLabelsOnSegment() {
    if UserPrefs.weeksOption == 1 {
      freqSal.setTitle("2 Weekly", forSegmentAtIndex: 2)
      freqTakehome.setTitle("2 Weekly", forSegmentAtIndex: 2)
    }
    else if UserPrefs.weeksOption == 2 {
      freqSal.setTitle("4 Weekly", forSegmentAtIndex: 2)
      freqTakehome.setTitle("4 Weekly", forSegmentAtIndex: 2)
    }
    else {
      freqSal.setTitle("Weekly", forSegmentAtIndex: 2)
      freqTakehome.setTitle("Weekly", forSegmentAtIndex: 2)
    }
  }

  @IBAction func tapOnScreen(sender: UITapGestureRecognizer) {
    entrySalary.resignFirstResponder()
    doCalculations()
  }
  
  @IBAction func tapOnBottomUISegmentControl() {
    entrySalary.resignFirstResponder()
    doCalculations()
  }
  
  @IBAction func tapOnTopUISegmentControl() {
    entrySalary.resignFirstResponder()
    doCalculations()
  }

  //THIS METHOD SORT OF WORKS...NEATS NEATENING AND HANDLING FOR NIL
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  @IBAction func formattext(sender: UITextField) {
    currencyFormatInput.currencySymbol = "£"
    currencyFormatInput.numberStyle = .CurrencyStyle
    
    let checkText = Float(entrySalary.text!) ?? 0
    if (checkText == 0){
      entrySalary.text = nil
    }
    else {
      entrySalary.text = currencyFormatInput.stringFromNumber(checkText)
    }
  }
  
  //need to expland on the share functiionality!!!!!!!!!!
  @IBAction func tapOnShare(sender: UIBarButtonItem) {
    entrySalary.resignFirstResponder()
    doCalculations()
    
    let shareSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    let shareEMailAction = UIAlertAction(title: "Share Via E-Mail", style: .Default, handler: nil)
    let savePictureAction = UIAlertAction(title: "Save Graph To Pictures", style: .Default, handler: nil)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    shareSheet.addAction(shareEMailAction)
    shareSheet.addAction(savePictureAction)
    shareSheet.addAction(cancelAction)
    self.presentViewController(shareSheet, animated: true, completion: nil)
  }
  
  func test() {
    
  }
  
  

  func setChart(dataPoints: [String], values: [Double], centre: Float) {
    
    
    pieChartDisplay.descriptionText = ""
    //pieChartDisplay.userInteractionEnabled = false
    
    pieChartDisplay.animate(yAxisDuration: 0.50)
    pieChartDisplay.centerText = "£"+String(centre)
    pieChartDisplay.drawHoleEnabled = true
    pieChartDisplay.drawSlicesUnderHoleEnabled = true
    pieChartDisplay.usePercentValuesEnabled = true
    pieChartDisplay.legend.enabled = false
    pieChartDisplay.highlightPerTapEnabled = false
    pieChartDisplay.autoresizesSubviews = true
    pieChartDisplay.rotationEnabled = false
    pieChartDisplay.userInteractionEnabled = false
    
    
    
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
      let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
      dataEntries.append(dataEntry)
    }
    
    let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: nil)
    let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
    pieChartDisplay.data = pieChartData
    
    pieChartDataSet.xValuePosition = .OutsideSlice
    pieChartDataSet.selectionShift = 2.5
    pieChartDataSet.sliceSpace = 2.5
    //pieChartDisplay.legend.position = .PiechartCenter   ???depraacted????
    pieChartDataSet.colors = ChartColorTemplates.material()
    /*
    let legend = pieChartDisplay.legend
    legend.enabled = true
    legend.drawInside = true
     */
  }

}

