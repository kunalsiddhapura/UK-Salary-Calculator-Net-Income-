//
//  SalaryCalculatorBrains.swift
//  SalaryCalculator
//
//  Created by Kunal Siddhapura on 27/07/2016.
//  Copyright © 2016 Kunal Siddhapura. All rights reserved.
//

import Foundation

struct AnnualSalary {
  
	func calculateAnnualSalary(enteredSalary: Float, frequencyChosen:Int) -> Float {
		//Calcualte Annual Salary
    var annualSalary: Float!
    
    let weeksMultiplier: Float!
    switch UserPrefs.weeksOption {
      case 1: weeksMultiplier = 52 / 2
      case 2: weeksMultiplier = 52 / 4
      default: weeksMultiplier = 52
    }
    
    switch frequencyChosen {
      case 0: annualSalary = enteredSalary
      case 1: annualSalary = enteredSalary * 12
      case 2: annualSalary = enteredSalary * weeksMultiplier
      case 3: annualSalary = ((enteredSalary * UserPrefs.daysPerWeek) * 52)
      case 4: annualSalary = ((enteredSalary * UserPrefs.hoursPerWeek) * 52)
      default: annualSalary = enteredSalary
    }
    return annualSalary
	}
}

struct DisplayOutput{
  
  func displayOutput(chosenOutput:Float, frequencyOfOutput:Int) -> Float{
    let outputToBeDisplayed: Float!
    
    var weeksMultiplier: Float! = 52
    
    //CAN BE REFACTORED -- MAYBE DO ALL MATHS IN USERPREFS STRUCT???
    if UserPrefs.weeksOption == 0 {
      weeksMultiplier = 52
    }
    else if UserPrefs.weeksOption == 1 {
      weeksMultiplier = 52 / 2
    }
    else if UserPrefs.weeksOption == 2 {
      weeksMultiplier = 52 / 4
    }
 
    switch frequencyOfOutput {
      case 0: outputToBeDisplayed = chosenOutput
      case 1: outputToBeDisplayed = chosenOutput / 12
      case 2: outputToBeDisplayed = chosenOutput / weeksMultiplier
      case 3: outputToBeDisplayed = ((chosenOutput / UserPrefs.daysPerWeek) / 52)
      case 4: outputToBeDisplayed = ((chosenOutput / UserPrefs.hoursPerWeek) / 52)
      default: outputToBeDisplayed = chosenOutput
    }
    return outputToBeDisplayed
  }
}

struct UserPrefs{
  
  static var hoursPerWeek: Float = 37
  static var daysPerWeek: Float = 5
  static var pensionContribution:Float = 0 // Decimal form of Percentage
  static var studentLoanOption: Int = 0 // This Int will only be 0,1,2 - As it gets it value from a segment bar
  static var weeksOption: Int = 0 // This Int will only be 0,1,2 - As it gets it value from a segment bar
  static var nationalInsuranceOption: Int = 0 // This Int will only be 0,1 - As it gets it value from a segment bar
  static var registeredBlind: Bool = false
  static var age: Int = 0 // This Int will only be 0,1 - As it gets it value from a segment bar
}

class TaxConstants{
  //Personal Allowances
  let personalTaxFreeAllowance:Float = 11000
  //Tax Bands & Rates
  let basicTaxRateUpperLimit: Float = 32000 // Max Income for basic rate tax after tax allowances
  let higherTaxRateUpperLimit: Float = 150000 // Max Income for higher rate tax after tax allowances
  let basicTaxRate:Float = 0.2 // Decimal of 20%
  let higherTaxRate:Float = 0.4 // Decimal of 40%
  let additionalTaxRate:Float = 0.45 // Decimal of 45%
  
  //National Insurance Constants
  let NIPaymentThreshold:Float = 8060 // Equivalent to £155 per week
  let NIBasicIncomeLimit:Float = 43000
  let standardNIRate: Float = 0.12 // Decimal of 12%
  let additionalNIRate: Float = 0.02 // Decimal of 2%
  
  //Student Loan
  let planONEThreshold: Float = 17495 // Equivalent to £336 a week
  let planTWOThreshold: Float = 21000 // Equivalent to £403 a week
  let studentLoanRate: Float = 0.09 //Decimal of 9%
  
  //Blind Persons Allowance
  let registeredBlindPersonalAllowance: Float = 2290 // Annual additional tax free allowance for registered blind
  }

class SalaryCalculatorBrains: TaxConstants {

	func calculateTotalTaxFreeAllowance(annualSalary: Float) -> Float {
		var totalTTaxFreeAllowance: Float! = 0
		let localAnnualSalary = annualSalary - calculateAnnualPension(annualSalary)
    
    if localAnnualSalary <= 100000 {
			totalTTaxFreeAllowance = personalTaxFreeAllowance + calculateBlindPersonsAllowance(UserPrefs.registeredBlind)
			return totalTTaxFreeAllowance
		}
		else if localAnnualSalary >= 122000{
			totalTTaxFreeAllowance = 0 + calculateBlindPersonsAllowance(UserPrefs.registeredBlind)
			return totalTTaxFreeAllowance
		}
		else if localAnnualSalary > 121999 && localAnnualSalary < 122000{
			totalTTaxFreeAllowance = 1 + calculateBlindPersonsAllowance(UserPrefs.registeredBlind)
			return totalTTaxFreeAllowance
		}
		else {
			let amountOver:Float = (122000 - floor(localAnnualSalary))
			totalTTaxFreeAllowance = (round(amountOver / 2)) + calculateBlindPersonsAllowance(UserPrefs.registeredBlind)
			return totalTTaxFreeAllowance
		}
	}
  
  func calculateTotalTaxableIncome(annualSalary: Float) -> Float {
    let localPensionAmount = calculateAnnualPension(annualSalary)
    let localAdjustedIncome = annualSalary - localPensionAmount
    var totalAnnualTaxableIncome:Float! =
    (localAdjustedIncome - calculateTotalTaxFreeAllowance(annualSalary))
    
    if (totalAnnualTaxableIncome >= 0){
      return totalAnnualTaxableIncome
    }
    else {
      totalAnnualTaxableIncome = 0
      return totalAnnualTaxableIncome
    }
  }
  
  func calculateAnnualTaxPayment(totalTaxableIncome:Float) -> Float{
    var totalAnnualTax: Float

    let maxBasicTaxRatePaid:Float = basicTaxRateUpperLimit * basicTaxRate
    let maxHigherTaxRatePaid: Float = ((higherTaxRateUpperLimit - basicTaxRateUpperLimit) * higherTaxRate) + maxBasicTaxRatePaid
    
    if totalTaxableIncome == 0 {
      totalAnnualTax = 0
      return totalAnnualTax
    }
    else if totalTaxableIncome <= basicTaxRateUpperLimit {
      totalAnnualTax = totalTaxableIncome * basicTaxRate
      return totalAnnualTax
    }
    else if totalTaxableIncome <= higherTaxRateUpperLimit {
      totalAnnualTax = (totalTaxableIncome-basicTaxRateUpperLimit)*higherTaxRate
      totalAnnualTax = totalAnnualTax + maxBasicTaxRatePaid
      return totalAnnualTax
    }
    else {
      totalAnnualTax = (totalTaxableIncome - higherTaxRateUpperLimit)*additionalTaxRate
      totalAnnualTax = totalAnnualTax + maxHigherTaxRatePaid
      return totalAnnualTax
    }
  }
	
  func calculateNIContributions(annualSalary:Float) -> Float {
    var NIContributions: Float!
    let maxStandardNIPaid: Float = (NIBasicIncomeLimit - NIPaymentThreshold)*standardNIRate
    
    if UserPrefs.nationalInsuranceOption == 0 && UserPrefs.age == 0 {
      if annualSalary <= NIPaymentThreshold {
        NIContributions = 0
      }
      else if annualSalary <= NIBasicIncomeLimit {
        NIContributions = (annualSalary - NIPaymentThreshold) * standardNIRate
      }
      else {
        NIContributions = ((annualSalary - NIBasicIncomeLimit) * additionalNIRate) + maxStandardNIPaid
      }
      return NIContributions
    }
    else if UserPrefs.nationalInsuranceOption == 1 || UserPrefs.age == 1{
      NIContributions = 0
    }
    return NIContributions
  }
  
  func calculateStudentLoan(annualSalary:Float,optionChosen:Int) -> Float {
    let annualStudentLoan: Float
    switch optionChosen{
      case 1:
        if annualSalary > planONEThreshold{
        annualStudentLoan = (annualSalary - planONEThreshold) * studentLoanRate
      }
        else {
          annualStudentLoan = 0
      }
      case 2:
        if annualSalary > planTWOThreshold{
        annualStudentLoan = (annualSalary - planTWOThreshold) * studentLoanRate
      }
        else{
          annualStudentLoan = 0
      }
      default:
        annualStudentLoan = 0
    }
    return annualStudentLoan
  }
  
  func calculateAnnualPension(annualSalary: Float) -> Float {
    //Calculate Annual Pension
    let annualPensionPaid:Float = annualSalary * UserPrefs.pensionContribution
    return annualPensionPaid
  }
  
  func calculateBlindPersonsAllowance(registeredBlind: Bool) -> Float {
    var blindPersonsAllowance: Float!
    if registeredBlind {
      blindPersonsAllowance = registeredBlindPersonalAllowance
    }
    else {
      blindPersonsAllowance = 0
    }
    return blindPersonsAllowance
  }
}