import UIKit

/**
    if let - guard let kullanım tercihi neye göre belirlenir?
    if let ile nilden kurtarilip degiskene atanan deger sadece if blogu arasinda calisir
    guard let ise tanimlanan scope sonrasinda her yerde kullanilabilir. Eger nil degil ise program crash verir.
     
    guard let genellikle istenilen degerin kesin olarak nil olmamasi istendigi durumlarda ve programin surekliligini ve devamliligini saglayan bu  degiskenin nil duruma dusmemesinin kontrol edilmesi gerektigi zamanlarda kullanilir. Nil oldugu vakit program crash duruma gelir.
 
    iflet ise genelde anlik olarak nil degeri kontrollerinde kullanilir.Nil oldugunda genellikle programin crash vermesini etkileyecek duzeyde bir deger degildir.
 */

/**
 /// First Question
 /// Girilen bir sayının asal olup olmadığını bulan bir extension yazınız.
 */

extension Int {
    func isPrime() -> Bool {
        if self < 2{
            return false
        }else if self <= 3{
            return true
        }
        for i in 2...Int(sqrt(Double(self))) {
            if self % i == 0 {
                return false
            }
        }
        return true
    }
}

11.isPrime()

/**
 /// Second Question
 /// İki parametreli ve FARKLI tipli bir generic örneği yapınız... (T, U) ???
 */

func concatWithSpace<T: Numeric, U: Sequence>(first: T, second: U) -> U {
    //Append element by first parameter
    for i in second {
        print("\(i) \(first)")
    }
    return second
}

concatWithSpace(first: 45, second: ["Aphid", "Bumblebee", "Cicada", "Damselfly", "Earwig",2])

/**
 Project Euler 6.Question
 Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
 */

func diffSumOfSquares(upto: Int) -> Int{
    // Sum of the squares formula is n * (n+1) * (2*n+1) / 6
    let sumOfTheSquares = upto * (upto + 1) * (2 * upto + 1) / 6
    
    let squareOfSum = Int(pow(Double(upto * (upto + 1) / 2), Double(2)))
    
    return squareOfSum - sumOfTheSquares
}

print(diffSumOfSquares(upto: 100))
