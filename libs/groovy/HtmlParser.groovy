import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.io.File;
import java.io.IOException;


def call(filePath) {
        print filePath
        def doc = null, totCoverage = 0, avgCoverage = 0
         try {
                doc = Jsoup.parse(new File(filePath), "ISO-8859-1")
                def elements = doc.select("div.clearfix span.strong")
                for (def e : elements) {
                        def coverageVal = e.text().replace("%", "").trim() as Double
                        totCoverage = totCoverage + coverageVal
                }
                avgCoverage = (totCoverage / elements.size()).round(1)
        } catch (Exception e) {
                print e;
        } 
        return avgCoverage
}

return this;




