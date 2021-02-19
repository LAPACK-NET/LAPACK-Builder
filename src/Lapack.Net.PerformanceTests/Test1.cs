using BenchmarkDotNet.Attributes;
using LAPACK.NET;
using System.Linq;

namespace Lapack.Net.PerformanceTests
{
    public class Test1 : PerformanceTest
    {
        private double[] a0;
        private double[] b0;
        private int[] ipvt0;
        private int n = 2;
        private int nrhs = 1;
        private int lda = 2;
        private int ldb = 2;
        private int infos0 = 0;

        [GlobalSetup]
        public void Setup()
        {
            // 5X - 2Y = 7 
            // -X +  Y = 1
            double[] a = { 5, -1, -2, 1 };
            double[] b = { 7, 1 };
            
            a0 = a.ToArray();
            b0 = b.ToArray();
            ipvt0 = new int[n];
        }

        [Benchmark]
        public void TestMethod()
        {
            Test.lapack_dgesv(ref n, ref nrhs, a0, ref lda, ipvt0, b0, ref ldb, ref infos0);
        }
    }
}