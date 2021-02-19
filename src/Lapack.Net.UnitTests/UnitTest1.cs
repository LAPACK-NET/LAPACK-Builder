using LAPACK.NET;
using NUnit.Framework;
using System.Linq;

namespace Lapack.Net.UnitTests
{
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void Test1()
        {
            // 5X - 2Y = 7 
            // -X +  Y = 1
            double[] a = { 5, -1, -2, 1 };
            double[] b = { 7, 1 };

            int n = 2;
            int nrhs = 1;
            int lda = 2;
            int ldb = 2;
            int infos0 = 0;

            var a0 = a.ToArray();
            var b0 = b.ToArray();
            int[] ipvt0 = new int[n];

            Test.lapack_dgesv(ref n, ref nrhs, a0, ref lda, ipvt0, b0, ref ldb, ref infos0);

            Assert.AreEqual(3, b0[0], 0.01);
            Assert.AreEqual(4, b0[1], 0.01);
        }
    }
}