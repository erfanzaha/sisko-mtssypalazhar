<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Exam_card extends Admin_Controller {
    
    /**
     * Class Constructor
     *
     * @return Void
     */
    public function __construct() {
        parent::__construct();
        $this->load->model(['m_admission_exam_schedule_details', 'm_registrants']);
    }

    /**
	  * Print PDF Registration Form
	  */
	public function pdf() {
		$id = $this->uri->segment(4);
		if ( ! _isNaturalNumber( $id ) ) return show_404();
		$query = $this->model->RowObject('id', $id, 'users');
		if ( ! is_object($query)) return show_404();
		$res = $this->m_registrants->find_registrant($query->registration_number, $query->birth_date);
		$schedules = $this->m_admission_exam_schedule_details->get_student_exam_schedules($id);
		if ( ! is_object($schedules)) return show_404();
		$file_name = 'kartu-peserta-ujian-penerimaan-peserta-didik-baru-tahun-' . substr($query->registration_number, 0, 4);
		$file_name .= '-' . $query->registration_number . '.pdf';
		$this->load->library('exam_cards');
		$this->exam_cards->pdf($res, $schedules, $file_name);
	}
}