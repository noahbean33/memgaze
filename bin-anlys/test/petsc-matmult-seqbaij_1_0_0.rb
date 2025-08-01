#!/usr/bin/env ruby
class Matmult_seqbaij_1_0_0
	def evalModel(funcs, loop1_its: 80000.0, loop1_1_its: 6.86, loop1_1_seg_0_unroll: 1)
		base_entry_0_0 = (0)/1.0 #cycles due to memop => 0, blks: 0->
		base_entry_0_1 = (0)/1.0 #cycles due to memop => 0, blks: 1->4->
		base_entry_0_2 = (0)/1.0 #cycles due to memop => 0, blks: 5->8->12->13->14->
		base_exit_0_0 = (0)/1.0 #cycles due to memop => 0, blks: 28->
		base_exit_0_1 = (0)/1.0 #cycles due to memop => 0, blks: 29->32->
		base_exit_0_2 = (0)/1.0 #cycles due to memop => 0, blks: 33->36->37->
		loop1_1_seg_0_vals = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0} #21->
		loop1_1_seg_0 = (loop1_1_seg_0_vals[loop1_1_seg_0_unroll]/loop1_1_seg_0_unroll) #cycles due to memop => 0, blks: 21->
		loop1_entry_0 = (0)*1.0/1.0 #cycles due to memop => 0, blks: 15->16->17->18->19->20->
		loop1_exit_0 = (0)*1.0/1.0 #cycles due to memop => 0, blks: 22->24->26->27->
		func_call_2=funcs["vecrestorearrayread"]
		func_call_3=funcs["vecrestorearray"]
		base_exit_0=(base_exit_0_0 + func_call_2 + base_exit_0_1 + func_call_3 + base_exit_0_2)*1.0
		func_call_0=funcs["vecgetarrayread"]
		func_call_1=funcs["vecgetarray"]
		base_entry_0=(base_entry_0_0 + func_call_0 + base_entry_0_1 + func_call_1 + base_entry_0_2)*1.0
		loop1_1_out_0=(loop1_1_seg_0)*1.0
		loop1_1=loop1_1_its*loop1_1_out_0
		loop1_path_0=(loop1_entry_0 + loop1_1 + loop1_exit_0)*1.0
		loop1_out_0=(loop1_entry_0 + loop1_1 + loop1_exit_0)*1.0
		loop1=loop1_its*(loop1_path_0) + loop1_out_0
		base_out_0=(base_entry_0 + loop1 + base_exit_0)*1.0
		return base_out_0
	end


" petsc code for reference:

PetscErrorCode MatMult_SeqBAIJ_1(Mat A,Vec xx,Vec zz)
{
  Mat_SeqBAIJ       *a = (Mat_SeqBAIJ*)A->data;
  PetscScalar       *z,sum;
  const PetscScalar *x;
  const MatScalar   *v;
  PetscErrorCode    ierr;
  PetscInt          mbs,i,n;
  const PetscInt    *idx,*ii,*ridx=NULL;
  PetscBool         usecprow=a->compressedrow.use;

  PetscFunctionBegin;
  ierr = VecGetArrayRead(xx,&x);CHKERRQ(ierr);
  ierr = VecGetArray(zz,&z);CHKERRQ(ierr);

  if (usecprow) {
    mbs  = a->compressedrow.nrows;
    ii   = a->compressedrow.i;
    ridx = a->compressedrow.rindex;
    ierr = PetscMemzero(z,mbs*sizeof(PetscScalar));CHKERRQ(ierr);
  } else {
    mbs = a->mbs;
    ii  = a->i;
  }

  for (i=0; i<mbs; i++) {
    n   = ii[1] - ii[0];
    v   = a->a + ii[0];
    idx = a->j + ii[0];
    ii++;
    PetscPrefetchBlock(idx+n,n,0,PETSC_PREFETCH_HINT_NTA);   /* Indices for the next row (assumes same size as this one) */
    PetscPrefetchBlock(v+1*n,1*n,0,PETSC_PREFETCH_HINT_NTA); /* Entries for the next row */
    sum = 0.0;
    PetscSparseDensePlusDot(sum,x,v,idx,n);
    if (usecprow) {
      z[ridx[i]] = sum;
    } else {
      z[i]        = sum;
    }
  }
  ierr = VecRestoreArrayRead(xx,&x);CHKERRQ(ierr);
  ierr = VecRestoreArray(zz,&z);CHKERRQ(ierr);

  //palm_task_model((uint32_t)(2.0*a->nz - a->nonzerorowcnt), 0, 0, 0);

  ierr = PetscLogFlops(2.0*a->nz - a->nonzerorowcnt);CHKERRQ(ierr);
  PetscFunctionReturn(0);
}


#define PetscSparseDensePlusDot(sum,r,xv,xi,nnz) { \
    PetscInt __i; \
    for (__i=0; __i<nnz; __i++) sum += xv[__i] * r[xi[__i]];}
#endif

"
