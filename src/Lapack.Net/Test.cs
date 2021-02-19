using System.Runtime.InteropServices;

namespace LAPACK.NET
{
    public class Test
    {
        [DllImport("native/liblapack", EntryPoint = "dgesv_", CallingConvention = CallingConvention.Cdecl)]
        public static extern void lapack_dgesv(ref int n, ref int nrhs, double[] a, ref int lda, int[] ipvt, double[] b, ref int ldb, ref int infos);
    }
}
