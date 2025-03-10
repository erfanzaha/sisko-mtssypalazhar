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

class M_subject_teachers extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'course_classes';
	
	/**
	 * Get Subjects
	 * @param Integer $academic_year_id
	 * @param Integer $semester
	 * @param Integer $class_group_id
	 * @return Resource
	 */
	public function get_subjects($academic_year_id, $semester, $class_group_id) {
		$data = [];
		$query = $this->db
			->select('x1.id, x2.subject_name, x1.employee_id')
			->join('subjects x2', 'x1.subject_id = x2.id', 'LEFT')
			->where('x1.academic_year_id', $academic_year_id)
			->where('x1.semester', $semester)
			->where('x1.class_group_id', $class_group_id)
			->get(self::$table .' x1');
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[] = [
					'id' => $row->id,
					'subject_name' => $row->subject_name,
					'employee_id' => $row->employee_id
				];
			}
		}
		return $data;
	}

	/**
	 * Save Subject Teachers
	 * @param Array $course_classes
	 * @return Boolean
	 */
	public function save($course_classes) {
		$counter = 0;
		foreach ($course_classes as $row) {
			$dataset = [
				'updated_by' => __session('user_id'),
				'employee_id' => $row['employee_id']
			];
			$id = $row['id'];
			$query = $this->db
				->where('id', $id)
				->update(self::$table, $dataset);
			if ($query) {
				$counter++;
			}
		}
		return $counter > 0;
	}
}
