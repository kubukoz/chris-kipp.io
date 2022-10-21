//> using scala "3.2.0"
//> using lib "org.scala-lang::scala3-compiler:3.2.0"

import java.io.PrintWriter
import java.io.File

import dotty.tools.dotc.config.ScalaSettings

@main def showSettings() =
  val pw = new PrintWriter(new File("scala3-scalac-options.txt"))
  pw.write("scalac options for 3.2.0\n")
  pw.write("--------------------------------\n")
  val allSettings = new ScalaSettings().allSettings
  allSettings.foreach { setting =>
    pw.write(s"${setting.name}\n")
    pw.write(s"\t${setting.description}\n")
  }
  pw.close


