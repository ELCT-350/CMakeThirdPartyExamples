#include <sciplot/sciplot.hpp>
#include <vector>

using namespace std;
using namespace sciplot;

int main()
{
  Plot plot;
  plot.drawCurve(vector<int>({ 1, 2, 3, 4 }), vector<int>({ 1, 3, 2, 4 })).label("Example");
  plot.show();
  return 0;
}

//Or, if using matplotlib
//#include <string> //matplotlibcpp.h uses stod, but doesn't include string
//#include <matplotlibcpp.h>
//using namespace std;
//using namespace matplotlibcpp;
//
//int main()
//{
//  plot({ 1,3,2,4 });
//  show();
//
//  return 0;
//}