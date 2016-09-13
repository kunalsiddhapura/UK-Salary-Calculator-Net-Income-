//
//  SettingsController.swift
//  SalaryCalculator
//
//  Created by Kunal Siddhapura on 17/08/2016.
//  Copyright © 2016 Kunal Siddhapura. All rights reserved.
//

import UIKit
import Foundation

let settingsSyncNotificationKey = "salaryCalculator.specialNotificationKey"
let changeOfWeeklyOptionKey = "salaryCalculator.changeOfWeeklyOptionsKey"
class SettingsController: UIViewController {
  
  @IBOutlet weak var hoursPerWeekEntry: UITextField!
  @IBOutlet weak var daysPerWeekEntry: UITextField!
  @IBOutlet weak var pensionContributionEntry: UITextField!
  @IBOutlet weak var studentLoanEntry: UISegmentedControl!
  @IBOutlet weak var weeksOption: UISegmentedControl!
  @IBOutlet weak var registeredBlindOption: UISegmentedControl!
  @IBOutlet weak var payingNIOption: UISegmentedControl!
  @IBOutlet weak var ageOption: UISegmentedControl!

  // Delegate Methods For Validating Text Prior To saveSettings() Being Called
  @IBAction func validateHoursPerWeek(sender: UITextField) {
    let checkNumber = Float(hoursPerWeekEntry.text!) ?? 0
    if (checkNumber == 0 || checkNumber > 168){
      hoursPerWeekEntry.text = nil
    }
  }
  
  @IBAction func validateDaysPerWeek(sender: UITextField) {
    let checkNumber = Float(daysPerWeekEntry.text!) ?? 0
    if (checkNumber == 0 || checkNumber > 7){
      daysPerWeekEntry.text = nil
    }
  }
  
  @IBAction func validatePensionContributions(sender: UITextField) {
    let checkNumber = Float(pensionContributionEntry.text!) ??  0
    if (checkNumber == 0 || checkNumber > 100){
      pensionContributionEntry.text = nil
    }
  }
  
  func saveSettings() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    let hoursPerWeek = Float(hoursPerWeekEntry.text!) ?? 37
    let daysPerWeek = Float(daysPerWeekEntry.text!) ?? 5
    let pensionContribution = Float(pensionContributionEntry.text!) ?? 0
    let studentLoanPlan = studentLoanEntry.selectedSegmentIndex
    let weeksOptionSelected = weeksOption.selectedSegmentIndex
    let payingNIOptionSelected = payingNIOption.selectedSegmentIndex
    
    var registeredBlindSelected: Bool! = false
    
    if registeredBlindOption.selectedSegmentIndex == 0 {
      registeredBlindSelected = false
    }
    else if registeredBlindOption.selectedSegmentIndex == 1 {
      registeredBlindSelected = true
    }
    
    let ageSelected = ageOption.selectedSegmentIndex
    
    UserPrefs.hoursPerWeek = hoursPerWeek
    UserPrefs.daysPerWeek = daysPerWeek
    UserPrefs.pensionContribution = pensionContribution / 100
    UserPrefs.studentLoanOption = studentLoanPlan
    UserPrefs.weeksOption = weeksOptionSelected
    UserPrefs.nationalInsuranceOption = payingNIOptionSelected
    UserPrefs.registeredBlind = registeredBlindSelected
    UserPrefs.age = ageSelected
  }
  
  @IBAction func tapOnStudentLoanSegment() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
  }
  
  @IBAction func tapOnWeeksOption() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
    NSNotificationCenter.defaultCenter().postNotificationName(changeOfWeeklyOptionKey, object: self)
  }
  
  @IBAction func tapOnRegisteredBlind() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
    NSNotificationCenter.defaultCenter().postNotificationName(changeOfWeeklyOptionKey, object: self)
  }
  
  @IBAction func tapOnNIOption() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
    NSNotificationCenter.defaultCenter().postNotificationName(changeOfWeeklyOptionKey, object: self)
  }
  
  @IBAction func tapOnAgeOption() {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
    NSNotificationCenter.defaultCenter().postNotificationName(changeOfWeeklyOptionKey, object: self)
  }
  
  @IBAction func hideKeyboard(sender: UITapGestureRecognizer) {
    hoursPerWeekEntry.resignFirstResponder()
    daysPerWeekEntry.resignFirstResponder()
    pensionContributionEntry.resignFirstResponder()
    
    saveSettings()
    NSNotificationCenter.defaultCenter().postNotificationName(settingsSyncNotificationKey, object: self)
  }
}
